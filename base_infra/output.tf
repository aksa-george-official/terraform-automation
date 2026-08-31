output "private_subnet_id"{
  value = module.vpc.private_subnet_id
}  

output "User_Security_Group"{
  value = module.security_group.User_Security_Group
} 

output "Notification_Security_Group"{
  value = module.security_group.Notification_Security_Group
} 

output "Order_Security_Group"{
  value = module.security_group.Order_Security_Group
} 

output "user_repository_url"{
  value = module.ecr-repository.user_repo_url
} 

output "order_repository_url"{
  value = module.ecr-repository.order_repo_url
} 

output "notification_repository_url"{
  value = module.ecr-repository.notification_repo_url
} 

output "POSTGRES_USER"{
  value = module.database.POSTGRES_USER
} 

output "POSTGRES_HOST"{
  value = module.database.POSTGRES_HOST
} 

output "master_user_secret_arn"{
  value = module.database.master_user_secret_arn
} 

output "AWS_S3_BUCKET"{
  value = module.s3_buckets.s3_bucket_user
}

output "AWS_QUEUE_URL"{
  value = module.sqs_queue.AWS_QUEUE_URL
} 

output "listener_https_arn" {
  value = module.Load_Balancer.listener_https_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}