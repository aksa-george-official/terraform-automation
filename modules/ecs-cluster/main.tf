data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_ecs_cluster" "this" {
  name = "${local.tag_prefix}cluster"
}

resource "aws_autoscaling_group" "this" {
  name = "${local.tag_prefix}autoscaling-group"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  force_delete = true
  vpc_zone_identifier = var.private_subnet_id
  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }
  depends_on = [ aws_launch_template.this ]
  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "this" {
  name_prefix = "${local.tag_prefix}"
  image_id = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = "t3.medium"
  tags = {
    Name = "${local.tag_prefix}instance"
  }
  iam_instance_profile {
    name = var.ecs_instance_profile
  }
  user_data = base64encode(<<-EOF
  #!/bin/bash
  echo "ECS_CLUSTER=${aws_ecs_cluster.this.name}" >> /etc/ecs/ecs.config
EOF
)

}

resource "aws_ecs_capacity_provider" "this" {
  name = "${local.tag_prefix}provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 10
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
}
  }
  depends_on = [ aws_autoscaling_group.this ]
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name
  capacity_providers =[aws_ecs_capacity_provider.this.name]
  default_capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = aws_ecs_capacity_provider.this.name
    
  }
  depends_on = [ aws_ecs_capacity_provider.this ]
}

resource "aws_ecs_service" "user" {
  name = "${local.tag_prefix}user-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = var.user_task_defintion
  desired_count = 1
  force_new_deployment = true
  enable_execute_command = true
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  load_balancer {
    target_group_arn = var.user_target_group_arn
    container_name = var.container_name
    container_port = 8000
  }
  network_configuration {
    subnets = var.private_subnet_id

  security_groups = [
    var.User_Security_Group
  ]

  assign_public_ip = false
  }
}

resource "aws_ecs_service" "order" {
  name = "${local.tag_prefix}order-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = var.order_task_defintion
  desired_count = 1
  force_new_deployment = true
  enable_execute_command = true
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  load_balancer {
    target_group_arn = var.order_target_group_arn
    container_name = var.container_name
    container_port = 8000
  }
  network_configuration {
    subnets = var.private_subnet_id

  security_groups = [
    var.Order_Security_Group
  ]

  assign_public_ip = false
  }

}

resource "aws_ecs_service" "notification" {
  name = "${local.tag_prefix}notification-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = var.notification_task_defintion
  desired_count = 1
  force_new_deployment = true
  enable_execute_command = true
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  load_balancer {
    target_group_arn = var.notification_target_group_arn
    container_name = var.container_name
    container_port = 8000
  }
  network_configuration {
    subnets = var.private_subnet_id

  security_groups = [
    var.Notification_Security_Group
  ]

  assign_public_ip = false
  }
}