resource "aws_lambda_function" "dlq_handler" {
  function_name = "dlq_handler"
  role          = var.lambda_role_arn
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  filename      = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      FAILED_ORDERS_TABLE_NAME = "failed_orders"
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lambda_event_source_mapping" "dlq_trigger" {
  event_source_arn = var.dlq_arn
  function_name    = aws_lambda_function.dlq_handler.arn
  batch_size       = 1
}
