import gspread, json, boto3, os
from oauth2client.service_account import ServiceAccountCredentials

QUEUE_URL = os.environ["QUEUE_URL"]
SCOPE = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
CREDS = ServiceAccountCredentials.from_json_keyfile_name('client_secret.json', SCOPE)

def lambda_handler(event, context):
    client = gspread.authorize(CREDS)
    sqs_client = boto3.client('sqs')
    messages = sqs_client.receive_message(QueueUrl=QUEUE_URL, MaxNumberOfMessages=1)

    if 'Messages' in messages:  # when the queue is exhausted, the response dict contains no 'Messages' key
        message_body = json.loads(messages['Messages'][0]['Body'])
        sheet = client.open_by_url(message_body["spreadsheet_url"]).sheet1
        ids = message_body["students"]
        date = message_body["date"]

        col = len(sheet.row_values(1)) + 1
        # add a column header for the date
        sheet.update_cell(1, col, date)

        for id in ids:
            row_num = sheet.row_values(1).index(date) + 1
            col_num = sheet.col_values(1).index(id) + 1
            sheet.update_cell(col_num, row_num, '\U00002705')
        print("Spreadsheet updated")
        # next, we delete the message from the queue so no one else will process it again
        sqs_client.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=messages["Messages"][0]["ReceiptHandle"])
    else:
        print("THERE ARE NO MESSAGES, HOMIE")

    return {
        'statusCode': 200,
        'body': json.dumps('Success!')
    }

