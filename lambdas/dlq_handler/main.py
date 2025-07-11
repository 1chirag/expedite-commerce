import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['FAILED_ORDERS_TABLE_NAME'])

def lambda_handler(event, context):
    for record in event['Records']:
        try:
            msg_id = record['messageId']
            body = record['body']
            
            table.put_item(Item={
                'message_id': msg_id,
                'body': body,
                'status': 'FAILED'
            })
            print(f"Saved failed message {msg_id}")
        except Exception as e:
            print(f"Error: {str(e)}")
    return {"statusCode": 200}
