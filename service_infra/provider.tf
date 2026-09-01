# terraform {
#   required_providers {
#     aws = {
#         source = "hashicorp/aws"
#     }
#   }
# }


# provider "aws" {
#   region = var.region
# }



data "terraform_remote_state" "aksa-base-infra" {
  backend = "remote"

  config = {
    hostname     = "spacelift.io" # For US instance, use us.spacelift.io 
    organization = "aksa-george-official"    # 

    workspaces = {
      name = "aksa-base-infra"       # 
    }
  }
}

