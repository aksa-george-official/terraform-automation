output "ALB_Security_Group" {
  value = aws_security_group.alb.id
}

output "User_Security_Group" {
  value = aws_security_group.user-sg.id
}

output "RDS_Security_Group" {
  value = aws_security_group.RDS.id
}

output "Order_Security_Group" {
  value = aws_security_group.order-sg.id
}

output "Notification_Security_Group" {
  value = aws_security_group.notification-sg.id
}