resource "aws_security_group" "app_server" {
  name        = "asg-app-sg"
  description = "allow conections from the loadbalancer"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all to outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "asg-app-sg"
  }
}

resource "aws_security_group" "blue_green_lb" {
    name = "blue-green-lb-sg"
    description = "allow connection to the loadbalancer"
    vpc_id = data.aws_vpc.vpc.id
}