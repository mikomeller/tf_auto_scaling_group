variable "aws_region" {}

variable "owner_id" {}
variable "ami_name" {}
variable "instance_type" {}

variable "keypair" {}

variable "private_subnet_a" {}
variable "private_subnet_b" {}

variable "vpc_name" {
  description = "vpc-name"
  type        = string
}