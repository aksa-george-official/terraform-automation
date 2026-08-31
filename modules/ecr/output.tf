output "user_repo_url" {
  value = aws_ecr_repository.user.repository_url
}


output "order_repo_url" {
  value = aws_ecr_repository.order.repository_url
}

output "notification_repo_url" {
  value = aws_ecr_repository.notification.repository_url
}