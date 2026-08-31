resource "aws_sqs_queue" "this" {
  name = "${local.tag_prefix}main"
  delay_seconds = 90
  max_message_size = 2048
  message_retention_seconds = 86400
}