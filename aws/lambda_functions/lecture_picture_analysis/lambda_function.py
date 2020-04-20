import json, boto3
from PIL import Image

LECTURE_BUCKET = os.environ("LECTURE_BUCKET")
COLLECTION = os.environ("COLLECTION")
QUEUE_URL= os.environ("QUEUE_URL")

def lambda_handler(event, context):
    # prof_email/classroom_id/date.jpg
    s3_object_key = event["Records"][0]["s3"]["object"]["key"]
    s3_resource = boto3.resource('s3')
    date = s3_object_key.split("/")[2][0:-4]
    student_ids_in_lecture = []
    
    # download the file to the local file system for cropping
    my_bucket = s3_resource.Bucket(LECTURE_BUCKET)
    my_bucket.download_file(KEY, "temp.jpg")
    
    im = Image.open('temp.jpg')
    im = im.convert('RGB')
    
    idx = 0
    
    # call detect_faces on the image to get the bounding boxes
    for face in detect_faces(LECTURE_BUCKET, KEY):
        boundaries = face['BoundingBox']
        # once we have the boundaries, we need to use that to crop the image
        im = Image.open('temp.jpg')
        im = im.convert('RGB')
        width, height = im.size
        left = boundaries["Left"] * width
        top = boundaries["Top"] * height
        right = left + (boundaries["Width"] * width)
        bottom = top + (boundaries["Height"] * height)
        idx += 1
        output = 'test-face-' + str(idx) + '.jpg'
        # write the cropped img to an external file
        im.crop((left, top, right, bottom)).save(output, quality=95)
        with open(output, 'rb') as image:
            # check who this person is, and add them to student_ids_in_lecture
            search_faces_by_local_image(image.read(), COLLECTION, student_ids_in_lecture)

    sqs_client = boto3.client('sqs', region_name="us-east-1")
    
    message_body = json.dumps({"students": student_ids_in_lecture, "date": date, "spreadsheet": "test-attendance"})
    
    enqueue_response = sqs_client.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=message_body
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

def search_faces_by_local_image(image_file, collection_id, students, threshold=80, region="us-east-1"):
    rekognition = boto3.client("rekognition", region)
    response = rekognition.search_faces_by_image(
        Image={
            "Bytes": image_file
        },
        CollectionId=collection_id,
        FaceMatchThreshold=threshold,
    )

    if response['FaceMatches'][0]["Face"].get("ExternalImageId"):
        student_ids_in_lecture.append(response['FaceMatches'][0]["Face"].get("ExternalImageId"))
    else:
        print("FACE IDENTIFIED, BUT WAS NOT INDEXED IN REKOGNITION COLLECTION")

def detect_faces(bucket, key, attributes=['ALL'], region="us-east-1"):
    rekognition = boto3.client("rekognition", region)
    response = rekognition.detect_faces(
	    Image={
			"S3Object": {
				"Bucket": bucket,
				"Name": key,
			}
		},
	    Attributes=attributes,
	)
    return response['FaceDetails']
