import json, boto3

def lambda_handler(event, context):
    
    print(event)
    
    url = event["url"]
    prof_email = event["prof_email"]
    classroom_id = str(event["classroom_id"])
    prof_class = prof_email + ":" + classroom_id
    
    dynamodb = boto3.client('dynamodb')
    dynamodb.put_item(
        TableName='google-spreadsheets', 
        Item={
            'prof_email:classroom_id':{'S':prof_class},
            'url':{'S':url}
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
