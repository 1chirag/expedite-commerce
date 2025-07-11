output "order_queue_url" {
  value = aws_sqs_queue.order_queue.id
}

output "order_queue_arn" {
  value = aws_sqs_queue.order_queue.arn
}

output "dlq_url" {
  value = aws_sqs_queue.order_dlq.id
}

output "dlq_arn" {
  value = aws_sqs_queue.order_dlq.arn
}

output "queue_url" {
  value = aws_sqs_queue.order_queue.id
}
output "queue_arn" {
  value = aws_sqs_queue.order_queue.arn
}
