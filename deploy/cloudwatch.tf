resource "aws_cloudwatch_log_group" "guestbook" {
  name              = "/ecs/guestbook"
  retention_in_days = "1"
}