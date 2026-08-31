terraform {
  backend "s3" {
    bucket = "aksa-terraform-backend"
    key = "backend/service.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = "aksa-terraform-backend"
    key    = "backend/terraform.tfstate"
    region = var.region
  }
}