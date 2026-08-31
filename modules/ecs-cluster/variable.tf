variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type= number
}
variable "private_subnet_id" {
  type = list(string)
}
variable "ecs_instance_profile" {
  
}

variable "user_task_defintion" {
  
}

variable "user_target_group_arn" {
  
}

variable "container_name" {
  
}

variable "order_task_defintion" {
  
}

variable "order_target_group_arn" {
  
}

variable "notification_task_defintion" {
  
}

variable "notification_target_group_arn" {
  
}

variable "User_Security_Group" {
  
}

variable "Order_Security_Group" {
  
}

variable "Notification_Security_Group" {
  
}
