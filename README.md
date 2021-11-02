# Terraform script to setup an Application Loadbalancer

## Description
In this Terraform script, I am creating an **Application Load Balancer** which is associated to 3 Autoscaling Groups. This will Loadbalance the HTTP traffic among the EC2 instances in the AutoScaling Groups based on the path pattern in the header of the web request.


In This Application LoadBalancer, the traffic reaching to the Loadbalancer will split into 3 Target groups as below:

![](https://i.ibb.co/RbmfDJd/alb.png)

1. if the web request is to **example.tld**, the traffic will go to first target group
2. if the web request is to **example.tld/path1**, the traffic will go to second target group
3. if the web request is to **example.tld/path2**, the traffic will go to third target group
- You can change the values of **path1** and **path2** from *terraform.tfvars* according to your requirement.


## Features
- Fully Automated
- Easy to customise and use as the Terraform modules are created using variables,allowing the module to be customized without altering the module's own source code, and allowing modules to be shared between different configurations.
- This script will create a the infrastructure in default VPC. If you want to create your own VPC, [you may click here](https://github.com/dilshadkp/terraform-create-vpc.git).
- AWS informations are defined using tfvars file and can easily changed (Automated/Manual)
- Project name is appended to the resources that are creating which will make easier to identify the resources.

## Prerequisites
- Create an IAM user on your AWS console that have access to create the required resources.
- Create a dedicated directory where you can create terraform configuration files.
- Install Terraform. [Click here for Terraform installation steps](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
- Knowledge to the working principles of AWS services especially AutoScaling, Loadbalancers and EC2.

## Pre-Setup
- Define AWS region in which you are going to work in *terraform.tfvars*
```hcl
region          =   ""
```
- Set a Project name in *terraform.tfvars*
```hcl
project          =   ""
```

## 1.Fetch Available Availability Zones in the working AWS region
>This will fetch all available Availability Zones in working AWS region and store the details in variable *az*

```hcl
data "aws_availability_zones" "az" {
  state = "available"
}
```
## 2.Generate and upload SSH key-pair to AWS
- You can generate SSH key-pair from any Linux systems using *ssh-keygen* command as below:
>![alt text](https://i.ibb.co/bWC7wb7/ssh-keygen.png)

- Upload the generated SSH public key to AWS

```hcl
resource "aws_key_pair" "mykey" {
  key_name      = "mykey"
  public_key    = "ssh-rsa AAAAB3NzaC1yc------------------------------------------------------------
-------------------------------------------------------------------------------------.compute.internal"
}
```
# 3.Create Security Group for instnaces in the AutoScaling Group

```hcl
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
```

# 4.Create Target Groups
>This will create 3 Target Groups which are handling traffic with 3 different headers as explained in the Description.

#### Target Group for example.tld

```hcl
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
```
#### Target Group for example.tld/path1

```hcl
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
```
#### Target Group for example.tld/path2

```hcl
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
```



# 5.Create Launch configurations

>AutoScaling Groups will use these Launch configurations to launch EC2 instances

#### Launch configuration for example.tld

```hcl
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
```

#### Launch configuration for example.tld/path1

```hcl
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
```

#### Launch configuration for example.tld/path2

```hcl
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
```


# 6.Create AutoScaling Groups
This will create an AutoScaling Groups which launches ec2 instances as configured in above Launch Configurations.
You can set your **Desired capacity**, **Minimum capacity** and **Maximum capacity** of AutoScaling Groups in *terraform.tfvars* file.

- #### Autoscaling Group 1

>This Autoscaling group is for the instances hosting index site(example.tld)

```hcl
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
```
- #### Autoscaling Group 2

>This Autoscaling group is for the instances hosting path1 site(example.tld/path1)


```hcl
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
```
- #### Autoscaling Group 3

>This Autoscaling group is for the instances hosting path2 site(example.tld/path2)

```hcl
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
```

# 7.Create Application LoadBalancer

> Here, I added an output variable ***DNS-name-of-Loadbalancer*** to print the DNS name of the created Loadbalancer which will be used in DNS configuration of the website.

```hcl
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
```

# 8.Create Listener Rules
- #### Default Listener rule

>This rule will forward any requests otherthan `example.tld` or `example.tld/path1/*` or `example.tld/path2/*` to a fixed response as ***No Site Found***

```hcl
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
```
- #### Listener for example.tld

>This rule will forward all requests with header pattern / to index target group 

```hcl
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
```
- #### Listener for example.tld/path1

>This rule will forward all requests with header pattern */path1* to path1 target group 


```hcl
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
```
- #### Listener for example.tld/path2

>This rule will forward all requests with header pattern */path2* to path2 target group 


```hcl
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
```


#### Lets validate the terraform files using
```hcl
terraform validate
```
#### Lets plan the architecture and verify once again.
```hcl
terraform plan
```
#### Lets apply the above architecture to the AWS.
```hcl
terraform apply
```
