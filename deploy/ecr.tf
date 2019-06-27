resource "aws_iam_policy" "ecr-access" {
  name = "ecr-access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-ecr-access" {
  role       = "${aws_iam_role.ecs-execution-role.name}"
  policy_arn = "${aws_iam_policy.ecr-access.arn}"
}

resource "aws_ecr_repository" "guestbook" {
  name = "guestbook"
}