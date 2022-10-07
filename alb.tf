resource "aws_lb" "blue_green_website" {
  name               = "blue-green-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.blue_green_lb.id]
  subnets            = [data.aws_subnet.public_a.id, data.aws_subnet.public_b.id]

  tags = {
    Enviroment = "blue-green-lb"
  }
}

resource "aws_lb_target_group" "blue_group" {
  name = "blue-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group" "green_group" {
  name = "green-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_autoscaling_attachment" "green_asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.green_asg.id
  lb_target_group_arn    = aws_lb_target_group.green_group.arn
}

resource "aws_autoscaling_attachment" "blue_asg_tg" {
  autoscaling_group_name = aws_autoscaling_group.blue_asg.id
  lb_target_group_arn    = aws_lb_target_group.blue_group.arn
}

resource "aws_lb_listener" "blue_green_listener" {
  load_balancer_arn = aws_lb.blue_green_website.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    # instead of:
    # target_group_arn = aws_lb_target_group.blue_asg.arn
    # create forward rule to the 2 target groups
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.blue_group.arn 
      }
      target_group {
        arn = aws_lb_target_group.green_group.arn
      }
      stickiness {
        duration = 300
        enabled = true
      }
    }
  }
}