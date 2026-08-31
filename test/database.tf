module "database" {
  source              = "../modules/database"
  username            = "Aksa"
  db_name             = "postgres"
  engine              = "postgres"
  User_Security_Group = module.security_group.User_Security_Group
  RDS_Security_Group  = module.security_group.RDS_Security_Group
  private_subnet_id   = module.vpc.private_subnet_id
}