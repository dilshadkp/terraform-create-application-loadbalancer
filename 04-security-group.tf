######################################
#Security group
######################################
resource "aws_security_group" "webserver" {
  name          = "webserver-sg"
  description   = "allows 22, 80,443 anywhere"
  vpc_id        = aws_default_vpc.default.id

ingress = [
    {
      description       = "port 22"
      from_port         = "22"
      to_port           = "22"
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      security_groups   = []
      cidr_blocks       = []
      ipv6_cidr_blocks  = []
      self              = false
      prefix_list_ids   = []
    },
    {
      description       = "port 80"
      from_port         = "80"
      to_port           = "80"
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      self              = false
      prefix_list_ids   = []
      security_groups   = []
    },
    {
      description       = "port 443"
      from_port         = "443"
      to_port           = "443"
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      self              = false
      prefix_list_ids   = []
      security_groups   = []
    }
]
egress = [
     {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
     }
]
 tags = {
    Name    = "${var.project}-webserver-sg"
    Project = var.project
	}
}
