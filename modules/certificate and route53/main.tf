data "aws_route53_zone" "main" {
  name = "workshop.kvsandbox.link"
  private_zone = false
}

resource "aws_route53_zone" "this" {
  name = "aksa.workshop.kvsandbox.link"
  tags = {
    Name = "${local.tag_prefix}-hosted-zone"
    Environment = "dev"
}
}

resource "aws_route53_record" "aksa-ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "aksa.workshop.kvsandbox.link"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.this.name_servers
}

resource "aws_acm_certificate" "alb_cert" {
  domain_name = var.ALB_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "alb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type

  zone_id = aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "alb_cert" {
  certificate_arn = aws_acm_certificate.alb_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.alb_cert_validation :
    record.fqdn
  ]

  depends_on = [ aws_route53_record.aksa-ns ]
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "api.aksa.workshop.kvsandbox.link"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name = var.cloudfront_domain_name
  region = "us-east-1"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type

  zone_id = aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "cloudfront_cert" {
  certificate_arn = aws_acm_certificate.cloudfront_cert.arn
  region = "us-east-1"
  validation_record_fqdns = [
    for record in aws_route53_record.cloudfront_cert_validation :
    record.fqdn
  ]

  depends_on = [ aws_route53_record.aksa-ns ]
}

resource "aws_route53_record" "cloudfront" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "client.aksa.workshop.kvsandbox.link"
  type    = "A"

  alias {
    name                   = var.cloudfront_dns_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}