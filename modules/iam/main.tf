resource "aws_iam_policy" "ecs" {
  name = "${local.tag_prefix}-ecs-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecs:*",
          "ecr:*",
          "ssm:*",
          "s3:*",
          "sqs:*",

          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ]

        Resource = "*"
      }
    ]
  })

  tags = {
    Name = local.tag_prefix
  }
}


resource "aws_iam_role" "ecs" {
  name = "${local.tag_prefix}-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_custom" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecs.arn
}


resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "ecs" {
  name = "${local.tag_prefix}-ecs-instance-profile"

  role = aws_iam_role.ecs.name
}