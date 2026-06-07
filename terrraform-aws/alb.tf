# Application Load Balancer
resource "aws_lb" "main" {
  name            = "${var.project_name}-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public[*].id

  enable_deletion_protection = false
  enable_http2               = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200-299"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# ALB Listener - HTTP
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.alb_port
  protocol          = var.enable_ssl ? "HTTPS" : "HTTP"
  ssl_policy        = var.enable_ssl ? "ELBSecurityPolicy-TLS-1-2-2017-01" : null
  certificate_arn   = var.enable_ssl ? var.ssl_certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# HTTP to HTTPS redirect listener (optional, only if SSL is enabled)
resource "aws_lb_listener" "http_redirect" {
  count             = var.enable_ssl ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
