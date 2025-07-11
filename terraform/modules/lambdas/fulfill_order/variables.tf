variable "lambda_zip_path" {
  description = "Path to the zipped lambda function code"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda execution"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
}