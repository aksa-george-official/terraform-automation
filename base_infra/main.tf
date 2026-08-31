module "cloudfront" {
  source = "../modules/cloudfront"
  s3_domain_name = module.s3_buckets.s3_bucket_domain_name
  cloudfront_certificate_arn = module.DNS.cloudfront_certificate_arn
}

module "database" {
  source              = "../modules/database"
  username            = "Aksa"
  db_name             = "postgres"
  engine              = "postgres"
  User_Security_Group = module.security_group.User_Security_Group
  RDS_Security_Group  = module.security_group.RDS_Security_Group
  private_subnet_id   = module.vpc.private_subnet_id
}

module "Load_Balancer" {
  source              = "../modules/load_balancer"
  ALB_Security_Group  = module.security_group.ALB_Security_Group
  public_subnet_id    = module.vpc.public_subnet_id
  alb_certificate_arn = module.DNS.alb_certificate_arn
  
  depends_on = [module.vpc, module.security_group]
}

module "sqs_queue" {
  source = "../modules/queue"
}

module "ecr-repository" {
  source = "../modules/ecr"
}

module "DNS" {
  source       = "../modules/certificate and route53"
  alb_dns_name = module.Load_Balancer.alb_dns_name
  alb_zone_id  = module.Load_Balancer.alb_zone_id
  cloudfront_dns_name = module.cloudfront. cloudfront_dns_name
  cloudfront_zone_id = module.cloudfront.cloudfront_zone_id
}

module "s3_buckets" {
  source = "../modules/s3"
  bucket_service = "${local.tag_prefix}user-bucket"
  bucket_frontend = "${local.tag_prefix}frontend-bucket"
  cloudfront_distribution_arn = [module.cloudfront.cloudfront_distribution_arn]
}

module "security_group" {
  source         = "../modules/security_groups"
  vpc_cidr_block = module.vpc.vpc_cidr_block
  vpc_id         = module.vpc.vpc_id
}

module "vpc" {
  source = "../modules/vpc"
  subnets = {
    public-a = {
      availability_zone = "ap-southeast-1a"
      cidr_block        = "10.0.1.0/24"
      type              = "public"

    }

    private-a = {
      availability_zone = "ap-southeast-1a"
      cidr_block        = "10.0.2.0/24"
      type              = "private"

    }

    public-b = {
      availability_zone = "ap-southeast-1b"
      cidr_block        = "10.0.3.0/24"
      type              = "public"

    }

    private-b = {
      availability_zone = "ap-southeast-1b"
      cidr_block        = "10.0.4.0/24"
      type              = "private"

    }
  }

  cidr_block = "10.0.0.0/16"
}