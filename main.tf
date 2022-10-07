data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Project"
    values = [var.vpc_name]
  }
}

data "aws_ami" "ubuntu_image" {
    owners = [var.owner_id]
    most_recent = true
    filter {
        name = "name"
        values = [var.ami_name]
    }
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["private_az_a"]
  }
}

data "aws_subnet" "private_b" {
  filter {
    name   = "tag:Name"
    values = ["private_az_b"]
  }
}
data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = ["public_az_a"]
  }
}
data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = ["public_az_b"]
  }
}