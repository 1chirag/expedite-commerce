resource "aws_lambda_function" "order_storage" {
  function_name       = "order_storage_lambda"
  role                = var.lambda_role_arn
  handler             = "main.lambda_handler"
  runtime             = "python3.12"
  filename            = var.lambda_zip_path
  source_code_hash    = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      ENV         = var.environment
      ORDERS_TABLE_NAME = "orders"  # DynamoDB table name used in Python
    }
  }

  tags = {
    Environment = var.environment
  }
}
