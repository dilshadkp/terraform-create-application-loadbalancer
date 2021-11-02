############################################
# ALB
############################################

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver.id]
  subnets            = data.aws_subnet_ids.default.ids

    tags        =   {
        Name    =   "${var.project}-alb"
        Project =   var.project
    }
}

output "DNS-name-of-Loadbalancer" {
    value   =   aws_lb.alb.dns_name
}
