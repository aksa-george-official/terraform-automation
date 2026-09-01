data "aws_db_parameter_group" "this" {
  name = "aksa-parameter-group-app"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.tag_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_id
}

resource "aws_kms_key" "this" {
  description = "KMS key for AKSA RDS"
}

resource "aws_db_instance" "this" {
  identifier = "${local.tag_prefix}-db"
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = "18.3"
  instance_class       = "db.t3.micro"
  port = 5432
  username = var.username
  storage_encrypted = true
  manage_master_user_password = true
  parameter_group_name = data.aws_db_parameter_group.this.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.RDS_Security_Group]
  db_subnet_group_name = aws_db_subnet_group.this.name
  tags = {
    Name= "${local.tag_prefix}-db"
  }
}