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
  role = "${aws_iam_role.guestbook-lambda-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
         {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": "*"
          }
      ]
}
EOF
}

resource "aws_lambda_function" "guestbook-lambda" {
  filename         = "../build/distributions/disruptive-guestbook-0.0.1-SNAPSHOT.zip"
  function_name    = "guestbook-lambda"
  role             = "${aws_iam_role.guestbook-lambda-role.arn}"
  handler          = "com.example.disruptiveguestbook.lambda.Handler"
  source_code_hash = "${base64sha256(file("../build/distributions/disruptive-guestbook-0.0.1-SNAPSHOT.zip"))}"
  runtime          = "java8"
  timeout          = 15
  memory_size      = 2048

  environment {
    variables = {
      SPRING_DATA_MONGODB_HOST = "${aws_docdb_cluster.guestbook-db-cluster.endpoint}"
    }
  }
}
