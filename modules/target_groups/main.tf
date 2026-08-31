resource "aws_lb_target_group" "this" {
  for_each = var.ALB_target_groups
  name  = each.value.name
  port = each.value.port
  protocol = each.value.protocol
  vpc_id = var.vpc_id
  target_type = "ip"
  health_check {
    path = each.value.health_check_path
    }
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.ALB_target_groups

  listener_arn = var.listener_https_arn
  priority     = each.key == "user_service" ? 100 : each.key == "order_service" ? 200 : 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path, "${each.value.path}/*"]
    }
  }
}