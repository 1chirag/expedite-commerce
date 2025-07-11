resource "aws_lambda_function" "fulfill_order" {
  function_name    = "fulfill_order_lambda"
  role             = var.lambda_role_arn
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      ORDERS_TABLE_NAME          = "orders"
      FAILED_ORDERS_TABLE_NAME   = "failed_orders"
    }
  }

  tags = {
    Environment = var.environment
  }
}
