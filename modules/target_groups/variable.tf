variable "ALB_target_groups" {
  type = map(object({
    name = string
    port = number
    protocol = string
    health_check_path = string
    path = string
  }))
}

variable "vpc_id" {
  
}

variable "listener_https_arn" {
  
}