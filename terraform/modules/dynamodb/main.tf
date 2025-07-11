resource "aws_dynamodb_table" "orders" {
  name           = var.orders_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }

  tags = {
    Name        = var.orders_table_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "failed_orders" {
  name           = var.failed_orders_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "message_id"  # <- match with DLQ Lambda

  attribute {
    name = "message_id"
    type = "S"
  }

  tags = {
    Name        = var.failed_orders_table_name
    Environment = var.environment
  }
}
