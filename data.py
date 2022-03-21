import configparser
import os.path
from typing import List, Dict, Optional, Any

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient import discovery
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

config = configparser.ConfigParser()
config.read('settings.ini')


def description(items: List[str]) -> Dict[str, Optional[type]]:
    values = dict(id=int)
    for item in items:
        if '[' in item:
            splited = item.split('[')
            values[splited[0]] = eval(splited[1][:-1])
        else:
            values[item] = None

    return values


def get_data():
    """Shows basic usage of the Sheets API.
    Prints values from a sample spreadsheet.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    try:
        service = build('sheets', 'v4', credentials=creds)

        # Call the Sheets API
        sheet: discovery.Resource = service.spreadsheets()

        _description = description(sheet.values().get(spreadsheetId=config['excel']['fileId'],
                                             range='A1:E1').execute().get('values', [])[0])

        result = sheet.values().get(spreadsheetId=config['excel']['fileId'],
                                    range='A2:E').execute()
        values: List[List[Any]] = result.get('values', [])
        for i, v in enumerate(values, 1):
            v.insert(0, i)

        data = [
            {
                name: ((v[i] if _type is None else (_type(v[i]) if (v[i] is not None and v[i] != '') else None)) if len(v) > i else None)
                for i, (name, _type) in enumerate(_description.items())
            }
            for v in values
        ]

        if not data:
            print('No data found.')
            return

        return data
    except HttpError as err:
        print(err)
