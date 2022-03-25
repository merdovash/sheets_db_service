import configparser
from datetime import datetime
from functools import lru_cache
from typing import List, Dict, Optional, Any

from googleapiclient.discovery import build

from oauth2client.service_account import ServiceAccountCredentials

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
    creds = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', SCOPES)

    service = build('sheets', 'v4', credentials=creds)

    # Call the Sheets API
    sheet = service.spreadsheets()

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


@lru_cache(10)
def _cached_sheet_data(key):
    return get_data()


def cached_sheet_data():
    return _cached_sheet_data(datetime.now().strftime('%Y-%m-%d %H-%M'))