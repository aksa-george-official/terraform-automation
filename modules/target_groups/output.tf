output "user_target_group_arn" {
  value = aws_lb_target_group.this["user_service"].arn
}

output "notification_target_group_arn" {
  value = aws_lb_target_group.this["notification_service"].arn
}

output "order_target_group_arn" {
  value = aws_lb_target_group.this["order_service"].arn
}