import json, os
from oauth2client.service_account import ServiceAccountCredentials

SCOPE = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
CREDS = ServiceAccountCredentials.from_json_keyfile_name('client_secret.json', SCOPE)

def lambda_handler(event, context):
    url = event["url"]
    uni_id = event["uni_id"]

    gc = gspread.authorize(CREDS)

    sheet = gc.open_by_url(url).sheet1

    row = len(sheet.col_values(1)) + 1
    col = 1

    sheet.update_cell(row, col, uni_id)

    return {
        'statusCode': 200,
        'body': json.dumps('Success!')
    }

def index_faces(bucket, key, collection_id, image_id=None, attributes=(), region="us-east-1"):
    rekognition = boto3.client("rekognition", region)
    response = rekognition.index_faces(
        Image = {
            "S3Object": {
                "Bucket": bucket,
                "Name": key,
            }
        },
        CollectionId=collection_id,
        ExternalImageId=image_id,
        DetectionAttributes=attributes,
    )
    return response['FaceRecords']
