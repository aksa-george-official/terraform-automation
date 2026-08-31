output "POSTGRES_HOST" {
  value = aws_db_instance.this.address
}

output "POSTGRES_USER" {
  value = var.username
}

output "master_user_secret_arn" {
  value = aws_db_instance.this.master_user_secret[0].secret_arn
}