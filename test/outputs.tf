output "user_queue_url" {
  value = module.sqs_queue.AWS_QUEUE_URL
}

output "db_address" {
  value = module.database.POSTGRES_HOST
}