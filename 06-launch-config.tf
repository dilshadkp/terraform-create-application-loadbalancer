######################################
#Launch configuration for index
######################################
resource "aws_launch_configuration" "index" {
  name_prefix        = "index-"
  image_id      = var.ami
  instance_type = var.type
  key_name      = "ssh-key-name"
  security_groups  = [aws_security_group.webserver.id]

  lifecycle {
    create_before_destroy = true
  }

}
######################################
#Launch configuration for path1
######################################
resource "aws_launch_configuration" "path1" {
  name_prefix        = "path-"
  image_id      = var.ami
  instance_type = var.type
  key_name      = "ssh-key-name"
  security_groups  = [aws_security_group.webserver.id]

  lifecycle {
    create_before_destroy = true
  }

}
######################################
#Launch configuration for path2
######################################
resource "aws_launch_configuration" "path2" {
  name_prefix        = "path2-"
  image_id      = var.ami
  instance_type = var.type
  key_name      = "ssh-key-name"
  security_groups  = [aws_security_group.webserver.id]

  lifecycle {
    create_before_destroy = true
  }

}
