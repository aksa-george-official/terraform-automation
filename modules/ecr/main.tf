resource "aws_ecr_repository" "user" {
  name = "${local.tag_prefix}-user_service_repo"
  tags = {
    Name = "${local.tag_prefix}-user-repo"
  }
}

resource "aws_ecr_repository" "order" {
  name = "${local.tag_prefix}-order_service_repo"
  tags = {
    Name = "${local.tag_prefix}-order-repo"
  }
}

resource "aws_ecr_repository" "notification" {
  name = "${local.tag_prefix}-notification_service_repo"
  tags = {
    Name = "${local.tag_prefix}-notification-repo"
  }
}