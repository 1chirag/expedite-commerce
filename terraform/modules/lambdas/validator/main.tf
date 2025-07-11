resource "aws_lambda_function" "validator" {
  function_name = "validator_lambda"
  role          = var.lambda_role_arn
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  filename      = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      ENV = var.environment
    }
  }

  tags = {
    Environment = var.environment
  }
}
