output "dlq_handler_lambda_arn" {
  value = aws_lambda_function.dlq_handler.arn
}
