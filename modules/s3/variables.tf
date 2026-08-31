variable "bucket_service" {
    type = string
    description = "name of the s3 bucket for user service"
}

variable "bucket_frontend" {
    type = string
    description = "name of the s3 bucket for frontend"
}   

variable "cloudfront_distribution_arn" {
  type = list(string)
}