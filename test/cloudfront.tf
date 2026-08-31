module "cloudfront" {
  source = "../modules/cloudfront"
  s3_domain_name = module.s3_buckets.s3_bucket_domain_name
  cloudfront_certificate_arn = module.DNS.cloudfront_certificate_arn
}