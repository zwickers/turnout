import json, boto3, os

BUCKET = os.environ["BUCKET"]
COLLECTION = os.environ["COLLECTION"]
REGION = os.environ["REGION"]

def lambda_handler(event, context):
    s3_object_key = event["Records"][0]["s3"]["object"]["key"]
    dot_idx = s3_object_key.index(".")
    uni_id = s3_object_key[:dot_idx]
    response = index_faces(BUCKET, s3_object_key, COLLECTION, image_id=uni_id, region=REGION)
    print(response)
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
