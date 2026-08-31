locals {
  public_subnets = {
    for name , subnet in var.subnets:
        name => subnet
        if subnet.type == "public"
  }
  tag_prefix = "Aksa-Infra-Vpc-"
}
