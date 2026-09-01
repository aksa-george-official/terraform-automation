module "target_group" {
  source = "../modules/target_groups"
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
  vpc_id              = var.vpc_id
  listener_https_arn = var.listener_https_arn
}

module "task_definition" {
  source              = "../modules/task-definition"
  container_name = "user"
  AWS_ACCESS_KEY_ID = ""
  AWS_SECRET_ACCESS_KEY = ""
  ecs_task_role       = module.iam_role.task_role_arn
  region = var.region
  user_repository_url = var.user_repository_url
  order_repository_url = var.order_repository_url
  notification_repository_url = var.notification_repository_url
  POSTGRES_USER = var.POSTGRES_USER
  POSTGRES_HOST = var.POSTGRES_HOST
  master_user_secret_arn = var.master_user_secret_arn
  AWS_S3_BUCKET = var.AWS_S3_BUCKET
  AWS_QUEUE_URL = var.AWS_QUEUE_URL
  
}

module "iam_role" {
  source = "../modules/iam"
}

module "ecs_cluster"{
    source = "../modules/ecs-cluster"
    min_size = 0
    max_size = 2
    desired_capacity = 2
    ecs_instance_profile = module.iam_role.ecs_instance_profile
    container_name = module.task_definition.container_name
    user_task_defintion = module.task_definition.user_task_defintion
    user_target_group_arn = module.target_group.user_target_group_arn
    order_target_group_arn = module.target_group.order_target_group_arn
    order_task_defintion = module.task_definition.order_task_defintion
    notification_target_group_arn = module.target_group.notification_target_group_arn
    notification_task_defintion = module.task_definition.notification_task_defintion
    private_subnet_id = var.private_subnet_id
    User_Security_Group = var.User_Security_Group
    Notification_Security_Group = var.Notification_Security_Group
    Order_Security_Group = var.Order_Security_Group

}