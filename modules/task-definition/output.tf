output "user_task_defintion" {
  value = aws_ecs_task_definition.user_service.arn
}

output "container_name" {
    value = var.container_name
}

output "task_definition_user_id" {
  value = aws_ecs_task_definition.user_service.id
}

output "order_task_defintion" {
  value = aws_ecs_task_definition.order_service.arn
}


output "task_definition_order_id" {
  value = aws_ecs_task_definition.order_service.id
}

output "notification_task_defintion" {
  value = aws_ecs_task_definition.notification_service.arn
}


output "task_definition_notification_id" {
  value = aws_ecs_task_definition.notification_service.id
}