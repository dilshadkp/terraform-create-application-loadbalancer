######################################
#Asg 1
######################################
resource "aws_autoscaling_group" "index" {
  name_prefix                      = "index-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.desired_size
  launch_configuration      = aws_launch_configuration.index.name
  target_group_arns         = [ aws_lb_target_group.index.arn ]
  vpc_zone_identifier       = [-choose-public-subnet-one-,-choose-public-subnet-two-]
  tag  {
    key     = "Name"
    value   = "index"
    propagate_at_launch = true
}
  lifecycle {
    create_before_destroy = true
  }
}
######################################
#Asg 2
######################################
resource "aws_autoscaling_group" "path1" {
  name_prefix                      = "path1-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.desired_size
  launch_configuration      = aws_launch_configuration.blog.name
  target_group_arns         = [ aws_lb_target_group.blog.arn ]
  vpc_zone_identifier       = [-choose-public-subnet-one-,-choose-public-subnet-two-]

  tag  {
    key     = "Name"
    value   = "path1"
    propagate_at_launch = true
}
  lifecycle {
    create_before_destroy = true
  }
}
######################################
#Asg for about
######################################
resource "aws_autoscaling_group" "path2" {
  name_prefix                      = "path2-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.desired_size
  launch_configuration      = aws_launch_configuration.about.name
  target_group_arns         = [ aws_lb_target_group.about.arn ]
  vpc_zone_identifier       = [-choose-public-subnet-one-,-choose-public-subnet-two-]

  tag  {
    key     = "Name"
    value   = "path2"
    propagate_at_launch = true
}
  lifecycle {
    create_before_destroy = true
  }
}
