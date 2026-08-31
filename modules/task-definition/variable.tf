variable "ecs_task_role" {

}
variable "user_repository_url" {
  
}

variable "order_repository_url" {
  
}

variable "notification_repository_url" {
  
}

variable "region" {
  
}
variable "container_name" {
  
}

variable "task_execution_role" {
  default = "arn:aws:iam::402338187344:role/ecsTaskExecutionRole"
}

variable "POSTGRES_HOST"{
  
} 
variable "master_user_secret_arn" {
  
}

variable "POSTGRES_USER" {
  
}

variable "AWS_QUEUE_URL" {
  
}

variable "AWS_S3_BUCKET" {
  
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  sensitive = true
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
  sensitive = true
}