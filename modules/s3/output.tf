output "s3_bucket_user" {
  value = var.bucket_service
}

output "s3_bucket_frontend" {
  value = var.bucket_frontend
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.frontend.bucket_domain_name
}