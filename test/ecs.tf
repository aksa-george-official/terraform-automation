module "task_definition" {
  source              = "../modules/task-definition"
  ecs_task_role       = module.iam_role.task_role_arn
  user_repository_url = module.ecr-repository.user_repo_url
  order_repository_url = module.ecr-repository.order_repo_url
  notification_repository_url = module.ecr-repository.notification_repo_url
  container_name = "user"
  POSTGRES_USER = module.database.POSTGRES_USER
  POSTGRES_HOST = module.database.POSTGRES_HOST
  master_user_secret_arn = module.database.master_user_secret_arn
  AWS_S3_BUCKET = module.s3_buckets.s3_bucket_user
  AWS_QUEUE_URL = module.sqs_queue.AWS_QUEUE_URL
  AWS_ACCESS_KEY_ID = ""
  AWS_SECRET_ACCESS_KEY = ""
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
    private_subnet_id = module.vpc.private_subnet_id
    container_name = module.task_definition.container_name
    user_task_defintion = module.task_definition.user_task_defintion
    user_target_group_arn = module.Load_Balancer.user_target_group_arn
    order_target_group_arn = module.Load_Balancer.order_target_group_arn
    order_task_defintion = module.task_definition.order_task_defintion
    notification_target_group_arn = module.Load_Balancer.notification_target_group_arn
    notification_task_defintion = module.task_definition.notification_task_defintion
    User_Security_Group = module.security_group.User_Security_Group
    Notification_Security_Group = module.security_group.Notification_Security_Group
    Order_Security_Group = module.security_group.Order_Security_Group

}