variable "lambda_zip_path" {
  type        = string
  description = "Path to the packaged lambda zip"
}

variable "state_machine_arn" {
  type        = string
  description = "ARN of the Step Function to trigger"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for the Lambda"
}

variable "environment" {
  type    = string
  default = "dev"
}