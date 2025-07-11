import json
import boto3
import os

stepfunctions = boto3.client('stepfunctions')

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    # Flexible: handle both {"body": "..."} and direct JSON dict (for testing)
    body = event.get('body')

    if isinstance(body, str):
        # Parse stringified JSON from body
        try:
            body = json.loads(body)
        except json.JSONDecodeError:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Invalid JSON in body"})
            }
    elif body is None:
        # Fallback for local testing where event is already the dict
        body = event

    order_id = body.get('order_id')

    if not order_id:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Missing order_id"})
        }

    try:
        response = stepfunctions.start_execution(
            stateMachineArn=os.environ['STATE_MACHINE_ARN'],
            input=json.dumps(body)
        )
    except Exception as e:
        print(f"Failed to start execution: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to start Step Function"})
        }

    return {
        "statusCode": 202,
        "body": json.dumps({
            "message": "Order received. Execution started.",
            "executionArn": response['executionArn']
        })
    }
