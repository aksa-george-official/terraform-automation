terraform {
  backend "s3" {
    bucket = "aksa-terraform-backend"
    key = "backend/base-infra.tfstate"
    region = "ap-southeast-1"
  }
}

