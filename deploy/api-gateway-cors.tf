resource "aws_api_gateway_method" "guestbook-api-options-method" {
    rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
    resource_id = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method_response" "guestbook-api-options-200-response" {
    rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
    resource_id = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
    http_method = "${aws_api_gateway_method.guestbook-api-options-method.http_method}"
    status_code   = "200"
    response_models {
        "application/json" = "Empty"
    }
    response_parameters {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = ["aws_api_gateway_method.guestbook-api-options-method"]
}

resource "aws_api_gateway_integration" "guestbook-api-options-integration" {
    rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
    resource_id = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
    http_method = "${aws_api_gateway_method.guestbook-api-options-method.http_method}"
    type          = "MOCK"

    request_templates = {
      "application/json" = <<EOF
{"statusCode": 200}EOF
    }
    depends_on = ["aws_api_gateway_method.guestbook-api-options-method"]
}

resource "aws_api_gateway_integration_response" "guestbook-api-options-integration-response" {
    rest_api_id = "${aws_api_gateway_rest_api.guestbook-api.id}"
    resource_id = "${aws_api_gateway_resource.guestbook-api-proxy-resource.id}"
    http_method = "${aws_api_gateway_method.guestbook-api-options-method.http_method}"
    status_code   = "${aws_api_gateway_method_response.guestbook-api-options-200-response.status_code}"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    response_templates = {
          "application/json" = <<EOF
EOF
    }

    depends_on = ["aws_api_gateway_method_response.guestbook-api-options-200-response"]
}
