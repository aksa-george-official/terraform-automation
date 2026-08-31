output "task_role_arn" {
 value = aws_iam_role.ecs.arn
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs.name
}