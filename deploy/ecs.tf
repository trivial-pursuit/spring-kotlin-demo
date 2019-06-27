resource "aws_ecs_cluster" "main" {
  name = "guestbook-cluster"
}

resource "aws_iam_role" "ecs-execution-role" {
  name = "ecs-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_ecs_service" "guestbook" {
  name            = "guestbook"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.guestbook.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = ["${data.aws_security_group.default.id}"]
    subnets          = ["${data.aws_subnet_ids.default.ids}"]
    assign_public_ip = true
  }

  load_balancer {
#    target_group_arn = "${aws_lb_target_group.service.id}"
    container_name   = "guestbook"
    container_port   = "8080"
  }
}

data "template_file" "container_definition" {
  template = <<EOF
[
  {
    "name": "guestbook",
    "image": "291404320502.dkr.ecr.eu-central-1.amazonaws.com/guestbook:1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "environment": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.guestbook.name}",
        "awslogs-region": "eu-central-1",
        "awslogs-stream-prefix": "guestbook"
      }
    }
  }
]
EOF
}

resource "aws_ecs_task_definition" "guestbook" {
  family                   = "guestbook"
  container_definitions    = "${data.template_file.container_definition.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "${aws_iam_role.ecs-execution-role.arn}"
}