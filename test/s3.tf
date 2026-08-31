module "s3_buckets" {
  source = "../modules/s3"
  bucket_service = "${local.tag_prefix}user-bucket"
  bucket_frontend = "${local.tag_prefix}frontend-bucket"
  cloudfront_distribution_arn = [module.cloudfront.cloudfront_distribution_arn]
}