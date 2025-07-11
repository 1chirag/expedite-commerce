resource "aws_lambda_function" "api_handler" {
  function_name = "api_handler"
  runtime       = "python3.12"
  handler       = "main.lambda_handler"
  filename      = var.lambda_zip_path

  source_code_hash = filebase64sha256(var.lambda_zip_path)

  role = var.lambda_role_arn

  environment {
    variables = {
      STATE_MACHINE_ARN = var.state_machine_arn
    }
  }

  tags = {
    Name        = "api_handler"
    Environment = var.environment
  }
}