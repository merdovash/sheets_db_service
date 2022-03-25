### Quickstart
1) Install requirements `pip install -r requirements.txt`
2) Create Google Sheets having first row as header and rest as body. You can specify type of column with python type in square bracers after name of column
3) Set Google Sheets fileId in `./settings.ini`
4) Read manual https://developers.google.com/sheets/api/quickstart/python and create Google Cloud Platform project
5) Get Service Account credentials of your project and put it in `./credentials.json`
6) Execute `uvicorn main:app --reload` to run server
