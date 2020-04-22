import json, gspread
from oauth2client.service_account import ServiceAccountCredentials

SCOPE = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
CREDS = ServiceAccountCredentials.from_json_keyfile_name('client_secret.json', SCOPE)

def lambda_handler(event, context):
    # TODO implement
    class_name = event["class_name"]
    prof_email = event["prof_email"]

    gc = gspread.authorize(CREDS)

    sheet = gc.create(class_name + " attendance")

    sheet.share(prof_email, perm_type='user', role='reader')

    spreadsheet = sheet.sheet1

    spreadsheet.update_cell(1, 1, "Student ID")

    return {
        'statusCode': 200,
        'body': json.dumps({"spreadsheet_url": sheet.url})
    }
