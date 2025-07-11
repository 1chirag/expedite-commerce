output "lambda_arn" {
  description = "ARN of the fulfill order Lambda function"
  value       = aws_lambda_function.fulfill_order.arn
}

output "function_name" {
  value = aws_lambda_function.fulfill_order.function_name
}