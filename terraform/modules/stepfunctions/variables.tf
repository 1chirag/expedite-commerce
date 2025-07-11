variable "validator_lambda_arn" {}
variable "order_storage_lambda_arn" {}
variable "sqs_queue_url" {}
variable "environment" {}
variable "step_function_role_arn" {
  description = "ARN of IAM role for Step Function"
  type        = string
}