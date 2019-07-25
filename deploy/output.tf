output "home" {
  value = "http://${aws_s3_bucket.guestbook.website_endpoint}"
}

output "api-endpoint" {
  value = "${aws_api_gateway_deployment.guestbook-api-deployment-default.invoke_url}"
}
