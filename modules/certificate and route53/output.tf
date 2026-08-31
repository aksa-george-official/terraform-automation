output "alb_certificate_arn" {
  value = aws_acm_certificate_validation.alb_cert.certificate_arn
}

output "cloudfront_certificate_arn" {
  value = aws_acm_certificate_validation.cloudfront_cert.certificate_arn
}