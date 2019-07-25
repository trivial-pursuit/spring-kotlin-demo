resource "aws_iam_role" "guestbook-api-role" {
  name = "guestbook-api-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "guestbook-api-policy" {
  name = "guestbook-api-policy"
  role = "${aws_iam_role.guestbook-api-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_rest_api" "guestbook-api" {
 name = "guestbook-api"

 endpoint_configuration {
     types = ["REGIONAL"]
 }
}

resource "aws_api_gateway_resource" "guestbook-api-proxy-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.guestbook-api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "guestbook-api-any-method" {
  rest_api_id   = "${aws_api_gateway_rest_api.guestbook-api.id}"
  resource_id   = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "guestbook-api-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
  resource_id = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
  http_method = "${aws_api_gateway_method.guestbook-api-any-method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.guestbook-lambda.invoke_arn}"

  credentials = "${aws_iam_role.guestbook-api-role.arn}"
}

resource "aws_api_gateway_deployment" "guestbook-api-deployment-default" {
  depends_on = ["aws_api_gateway_integration.guestbook-api-integration"]

  rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
  stage_name  = "default"
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.guestbook-api-deployment-default.invoke_url}"
}
