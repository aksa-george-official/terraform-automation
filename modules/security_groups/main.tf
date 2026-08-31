resource "aws_security_group" "alb" {
    name = "alb security group"
    description = "Allow http and https traffic to load balancer"
    vpc_id = var.vpc_id
    tags = {
      Name = "${local.tag_prefix}ALB "
    }
    lifecycle {
      create_before_destroy = true
    }
}
resource "aws_vpc_security_group_ingress_rule" "https-this" {
  security_group_id = aws_security_group.alb.id
  ip_protocol = "tcp"
  to_port = 443
  from_port = 443
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "http-this" {
  security_group_id = aws_security_group.alb.id
  ip_protocol = "tcp"
  to_port = 80
  from_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_security_group" "user-sg" {
  name = "user service sg"
  description = "To allow traffic from alb to user service"
  vpc_id = var.vpc_id
  tags = {
      Name = "${local.tag_prefix}USER "
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "user-this" {
  security_group_id = aws_security_group.user-sg.id
  ip_protocol = "tcp"
  to_port = 8000
  from_port = 8000
  referenced_security_group_id = aws_security_group.alb.id
  
}
resource "aws_vpc_security_group_egress_rule" "user_all" {
  security_group_id = aws_security_group.user-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "order-sg" {
  name = "order service sg"
  description = "To allow traffic from alb to order service"
  vpc_id = var.vpc_id
  tags = {
      Name = "${local.tag_prefix}ORDER "
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "order-this" {
  security_group_id = aws_security_group.order-sg.id
  ip_protocol = "tcp"
  to_port = 8000
  from_port = 8000
  referenced_security_group_id = aws_security_group.alb.id
  
}

resource "aws_vpc_security_group_egress_rule" "order_all" {
  security_group_id = aws_security_group.order-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "notification-sg" {
  name = "notification service sg"
  description = "To allow traffic from alb to notification service"
  vpc_id = var.vpc_id
  tags = {
      Name = "${local.tag_prefix}NOTIFICATION "
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "notification-this" {
  security_group_id = aws_security_group.notification-sg.id
  ip_protocol = "tcp"
  to_port = 8000
  from_port = 8000
  referenced_security_group_id = aws_security_group.alb.id
  
}

resource "aws_vpc_security_group_egress_rule" "notification_all" {
  security_group_id = aws_security_group.notification-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_security_group" "RDS" {
  name = "database sg"
  description = "To allow traffic between postgresa and rds"
  vpc_id = var.vpc_id
  tags = {
      Name = "${local.tag_prefix}DB "
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "database_from_user" {
  security_group_id            = aws_security_group.RDS.id
  referenced_security_group_id = aws_security_group.user-sg.id
  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432
}

resource "aws_vpc_security_group_ingress_rule" "database_from_order" {
  security_group_id            = aws_security_group.RDS.id
  referenced_security_group_id = aws_security_group.order-sg.id
  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432
}

resource "aws_vpc_security_group_ingress_rule" "database_from_notification" {
  security_group_id            = aws_security_group.RDS.id
  referenced_security_group_id = aws_security_group.notification-sg.id
  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432
}

resource "aws_vpc_security_group_ingress_rule" "database_from_cidr_block" {
  security_group_id            = aws_security_group.RDS.id
  cidr_ipv4 = var.vpc_cidr_block
  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432
}