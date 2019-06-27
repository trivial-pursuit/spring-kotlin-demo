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

resource "aws_security_group" "global-alb-access" {
  name   = "guestbook-global-alb-access"
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "80"
    to_port         = "80"
    security_groups = ["${aws_security_group.global-alb.id}"]
    description     = "global-alb-ingress"
  }

  ingress {
    protocol        = "tcp"
    from_port       = "8080"
    to_port         = "8080"
    security_groups = ["${aws_security_group.global-alb.id}"]
    description     = "global-alb-ingress"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "guestbook" {
  name                 = "guestbook"
  port                 = "8080"
  protocol             = "HTTP"
  vpc_id               = "${data.aws_vpc.default.id}"
  target_type          = "ip"
  deregistration_delay = "30"

  health_check {
    path                = "/actuator/health"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 2
  }
}

resource "aws_lb_listener_rule" "http" {
  listener_arn = "${aws_lb_listener.http.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.guestbook.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}

resource "aws_ecs_service" "guestbook" {
  name            = "guestbook"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.guestbook.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = ["${aws_security_group.global-alb-access.id}"]
    subnets          = ["${data.aws_subnet_ids.default.ids}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.guestbook.id}"
    container_name   = "guestbook"
    container_port   = "8080"
  }

  depends_on = ["aws_lb_listener.http"]
}

data "template_file" "container_definition" {
  template = <<EOF
[
  {
    "name": "guestbook",
    "image": "291404320502.dkr.ecr.eu-central-1.amazonaws.com/guestbook:0.0.1-SNAPSHOT",
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
