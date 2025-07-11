import json

def lambda_handler(event, context):
    print("Validator Lambda invoked")
    print("Received event:", event)

    required_keys = ["order_id", "product", "quantity"]
    for key in required_keys:
        if key not in event:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": f"Missing field: {key}"})
            }

    # ✅ Return just the validated data so order_storage can use it directly
    return {
        "order_id": event["order_id"],
        "product": event["product"],
        "quantity": event["quantity"]
    }
