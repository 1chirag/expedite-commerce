import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['ORDERS_TABLE_NAME'])  # You must set this as an environment variable

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    try:
        order_id = event['order_id']
        product = event['product']
        quantity = event['quantity']

        response = table.put_item(
            Item={
                'order_id': order_id,
                'product': product,
                'quantity': quantity,
                'status': 'PENDING'
            }
        )

        return {
            "order_id": order_id,
            "product": product,
            "quantity": quantity
        }

    except Exception as e:
        print(f"Error saving to DynamoDB: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to store order"})
        }
