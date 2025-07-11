resource "aws_sqs_queue" "order_dlq" {
  name = var.dlq_name

  tags = {
    Name        = var.dlq_name
    Environment = var.environment
  }
}

resource "aws_sqs_queue" "order_queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.order_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = var.queue_name
    Environment = var.environment
  }
}
