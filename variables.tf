data "aws_availability_zones" "azs" {
  state         = "available"
}
variable "region" {}
variable "project" {}
variable "vpc-cidr" {}
variable "vpc-subnet" {}
variable "type" {}
variable "ami" {}
variable "path1" {}
variable "path2" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_size" {}
