resource "aws_iam_role" "guestbook-lambda-role" {
  name = "guestbook-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "guestbook-lambda-policy" {
  name = "guestbook-lambda-policy"
  role = aws_iam_role.guestbook-lambda-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
         {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents",
                  "dynamodb:*"
              ],
              "Resource": "*"
          }
      ]
}
EOF

}

resource "aws_lambda_function" "guestbook-lambda" {
  filename      = "../build/distributions/function.zip"
  function_name = "guestbook-lambda"
  role          = aws_iam_role.guestbook-lambda-role.arn
  handler       = "com.example.disruptiveguestbook.lambda.Handler"
  source_code_hash = filebase64sha256(
    "../build/distributions/function.zip",
  )
  runtime     = "provided"
  timeout     = 15
  memory_size = 2048
}

