module "DNS" {
  source       = "../modules/certificate and route53"
  alb_dns_name = module.Load_Balancer.alb_dns_name
  alb_zone_id  = module.Load_Balancer.alb_zone_id
  cloudfront_dns_name = module.cloudfront. cloudfront_dns_name
  cloudfront_zone_id = module.cloudfront.cloudfront_zone_id
}