module "security_group" {
  source         = "../modules/security_groups"
  vpc_cidr_block = module.vpc.vpc_cidr_block
  vpc_id         = module.vpc.vpc_id
}