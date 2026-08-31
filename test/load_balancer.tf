module "Load_Balancer" {
  source              = "../modules/load_balancer"
  ALB_Security_Group  = module.security_group.ALB_Security_Group
  public_subnet_id    = module.vpc.public_subnet_id
  vpc_id              = module.vpc.vpc_id
  alb_certificate_arn = module.DNS.alb_certificate_arn
  ALB_target_groups = {
    user_service = {
      name              = "${local.tag_prefix}-user-service"
      port              = 8000
      protocol          = "HTTP"
      health_check_path = "/users/health"
      path              = "/users"
    }
    order_service = {
      name              = "${local.tag_prefix}order-service"
      port              = 8000
      protocol          = "HTTP"
      health_check_path = "/orders/health"
      path              = "/orders"
    }
    notification_service = {
      name              = "${local.tag_prefix}notification-service"
      port              = 8000
      protocol          = "HTTP"
      health_check_path = "/notifications/health"
      path              = "/notifications"
    }
  }
  depends_on = [module.vpc, module.security_group]
}
