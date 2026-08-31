resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.tag_prefix}-frontend-oac"
  description                       = "OAC for frontend S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.s3_domain_name
    origin_id = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }
  aliases = [ "client.aksa.workshop.kvsandbox.link" ]
  viewer_certificate {
    acm_certificate_arn = var.cloudfront_certificate_arn
    ssl_support_method = "sni-only"
  }
  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods =  ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      locations = []
      restriction_type = "none"
    }
  }
  default_root_object = "index.html"
  enabled = true
  tags = {
    Name = "${local.tag_prefix}-distribution"
    description = "cloudfront distribtution for frontend"
}
}