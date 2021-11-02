############################################
# target group for example.tld
############################################
resource "aws_lb_target_group" "index" {
    name        = "tg-index"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_default_vpc.default.id
    tags        =   {
        Name    =   "${var.project}-tg-index"
        Project =   var.project
    }

}
############################################
# target group for example.tld/path1
############################################
resource "aws_lb_target_group" "path1" {
    name        = "tg-path1"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_default_vpc.default.id
    tags        =   {
        Name    =   "${var.project}-tg-path1"
        Project =   var.project
    }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/var.path1"
    protocol            = "HTTP"
    matcher             = 200
    
  }

}
############################################
# target group for example.tld/path2
############################################
resource "aws_lb_target_group" "path2" {
    name        = "tg-path2"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_default_vpc.default.id
    tags        =   {
        Name    =   "${var.project}-tg-path2"
        Project =   var.project
    }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/var.path2"
    protocol            = "HTTP"
    matcher             = 200
    
  }

}
