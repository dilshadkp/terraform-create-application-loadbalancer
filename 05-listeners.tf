######################################
#Default listener
######################################

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>No Site Found</h1>"
      status_code  = "200"
    }
  }
}
######################################
# Listener for example.tld
######################################
resource "aws_lb_listener_rule" "index" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.index.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
######################################
# Listener for example.tld/path1
######################################
resource "aws_lb_listener_rule" "path1" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog.arn
  }

  condition {
    path_pattern {
      values = ["/var.path1/*"]
    }
  }
}
######################################
# Listener for example.tld/path2
######################################
resource "aws_lb_listener_rule" "path2" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.about.arn
  }

  condition {
    path_pattern {
      values = ["/var.path2/*"]
    }
  }
}
