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



data "terraform_remote_state" "source_stack" {
  backend = "remote"
  config = {
    hostname = "aksa-george-official.app.spacelift.io"
    organization = "aksa-george-official"
    workspaces = {
      name = "aksa-base-infra"
      }
      }
}

# Example: Reference an output value from the source stack