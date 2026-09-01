terraform {
  backend "s3" {
    bucket = "aksa-terraform-backend"
    key = "backend/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

