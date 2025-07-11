variable "orders_table_name" {
  type        = string
  description = "Name of the orders DynamoDB table"
}

variable "failed_orders_table_name" {
  type        = string
  description = "Name of the failed orders table"
}

variable "environment" {
  type        = string
  description = "Environment prod"
  default     = "dev"
}
