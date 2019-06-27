resource "aws_security_group" "global-alb" {
  name   = "Security group for global ALB"
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "global-alb" {
  name = "global-alb"
  internal = false

  subnets            = ["${data.aws_subnet_ids.default.ids}"]
  security_groups = ["${aws_security_group.global-alb.id}"]
}

resource "aws_lb_target_group" "default-http" {
  name     = "global-alb-HTTP-default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.default.id}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.global-alb.id}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello from ALB"
      status_code  = "200"
    }
  }
}

