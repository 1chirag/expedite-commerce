import json
import random
import boto3
import os

dynamodb = boto3.resource('dynamodb')
orders_table = dynamodb.Table(os.environ['ORDERS_TABLE_NAME'])
failed_orders_table = dynamodb.Table(os.environ['FAILED_ORDERS_TABLE_NAME'])

def lambda_handler(event, context):
    for record in event['Records']:
        try:
            body = json.loads(record['body'])
            order_id = body['order_id']

            # Simulate fulfillment
            if random.random() < 0.7:
                status = "FULFILLED"
            else:
                status = "FAILED"

            # Update main orders table
            orders_table.update_item(
                Key={'order_id': order_id},
                UpdateExpression="SET #s = :s",
                ExpressionAttributeNames={"#s": "status"},
                ExpressionAttributeValues={":s": status}
            )

            print(f"Order {order_id} processed with status: {status}")

            # If failed, also write to failed_orders
            if status == "FAILED":
                failed_orders_table.put_item(
                    Item={
                        "order_id": order_id,
                        "reason": "Simulated failure",
                        "timestamp": context.timestamp if hasattr(context, 'timestamp') else "N/A"
                    }
                )

        except Exception as e:
            print(f"Error processing order: {str(e)}")

    return {"statusCode": 200}
