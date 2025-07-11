variable "lambda_zip_path" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}
