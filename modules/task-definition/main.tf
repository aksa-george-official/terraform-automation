resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.tag_prefix}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "user_service" {
  family = "${local.tag_prefix}-user"
  network_mode = "awsvpc"
  task_role_arn       = var.ecs_task_role
  execution_role_arn = var.task_execution_role
  memory = 1024
  cpu = 256
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.user_repository_url
      essential = true
      cpu    = 256
      memory = 1024

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

     secrets = [{
      name      = "POSTGRES_PASSWORD"
      valueFrom =  "${var.master_user_secret_arn}:password::"
    }]
     environment = [
        {
          name  = "ENV"
          value = "dev"
        },
        {
          name  = "PORT"
          value = "8000"
        },
        {
          name  = "POSTGRES_HOST"
          value = var.POSTGRES_HOST
        },
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        },
        {
          name  = "POSTGRES_USER"
          value = var.POSTGRES_USER
        },
        {
          name  = "POSTGRES_DB"
          value = "user_db"
        },
        {
          name  = "AWS_QUEUE_URL"
          value = var.AWS_QUEUE_URL
        },
        {
          name  = "AWS_REGION"
          value = var.region
        },
        {
          name  = "AWS_S3_BUCKET"
          value = var.AWS_S3_BUCKET
        },
        {
          name  = "AWS_S3_REGION"
          value = var.region
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = var.AWS_ACCESS_KEY_ID
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.AWS_SECRET_ACCESS_KEY
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/${local.tag_prefix}"
          awslogs-stream-prefix = "ecs"
          awslogs-region = var.region
        }
      }

    
    }
  ])
}

resource "aws_ecs_task_definition" "order_service" {
  family = "${local.tag_prefix}-order"
  network_mode = "awsvpc"
  task_role_arn       = var.ecs_task_role
  execution_role_arn = var.task_execution_role
  memory = 1024
  cpu = 256
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.order_repository_url
      essential = true
      cpu    = 256
      memory = 1024

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

      secrets = [{
      name      = "POSTGRES_PASSWORD"
      valueFrom = "${var.master_user_secret_arn}:password::"
    }]
     environment = [
        {
          name  = "PORT"
          value = "8000"
        },
        {
          name  = "POSTGRES_HOST"
          value = var.POSTGRES_HOST
        },
      
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        },
        {
          name  = "POSTGRES_USER"
          value = var.POSTGRES_USER
        },
        {
          name  = "POSTGRES_DB"
          value = "order_db"
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/${local.tag_prefix}"
          awslogs-stream-prefix = "ecs"
          awslogs-region = var.region
        }
      }

    
    }
  ])
}

resource "aws_ecs_task_definition" "notification_service" {
  family = "${local.tag_prefix}-notification"
  network_mode = "awsvpc"
  task_role_arn       = var.ecs_task_role
  execution_role_arn = var.task_execution_role
  memory = 1024
  cpu = 256
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.notification_repository_url
      essential = true
      cpu    = 256
      memory = 1024

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

     secrets = [{
      name      = "POSTGRES_PASSWORD"
      valueFrom = "${var.master_user_secret_arn}:password::"
    }]
     environment = [
        {
          name  = "PORT"
          value = "8000"
        },
        {
          name  = "POSTGRES_HOST"
          value = var.POSTGRES_HOST
        },
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        },
        {
          name  = "POSTGRES_USER"
          value = var.POSTGRES_USER
        },
        {
          name  = "POSTGRES_DB"
          value = "notification_db"
        },
        {
          name  = "AWS_QUEUE_URL"
          value = var.AWS_QUEUE_URL
        },
        {
          name  = "AWS_REGION"
          value = var.region
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = "/ecs/${local.tag_prefix}"
          awslogs-stream-prefix = "ecs"
          awslogs-region = var.region
        }
      }

    
    }
  ])
}