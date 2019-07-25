resource "aws_cloudwatch_log_group" "guestbook-lambda-log-group" {
  name = "/aws/lambda/guestbook-lambda"
  retention_in_days = 1
}
