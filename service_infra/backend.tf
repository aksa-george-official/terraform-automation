terraform {
  backend "s3" {
    bucket = "aksa-terraform-backend"
    key = "backend/service.tfstate"
    region = "ap-southeast-1"
  }
}

data "terraform_remote_state" "aksa-base-infra" {
  backend = "s3"

  config = {
    bucket = "aksa-terraform-backend"
    key    = "base-infra.tfstate"
    region = var.region
 }
}