variable "lambda_role_arn" {
  description = "IAM role ARN for the lambda function"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the zipped lambda code"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "dlq_arn" {
  description = "ARN of the DLQ queue"
  type        = string
}
