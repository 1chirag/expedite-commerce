variable "queue_name" {
  type        = string
  description = "Name of the main order queue"
}

variable "dlq_name" {
  type        = string
  description = "Name of the dead-letter queue"
}

variable "environment" {
  type        = string
  default     = "dev"
}

