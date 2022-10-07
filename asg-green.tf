resource "aws_launch_template" "green_template" {
  name                   = "green-template"
  image_id               = data.aws_ami.ubuntu_image.id
  instance_type          = var.instance_type
  key_name               = var.keypair
  vpc_security_group_ids = [aws_security_group.app_server.id]
  user_data = base64encode(templatefile("${path.module}/user-data.sh.tpl", {
    version = "green website",
    color   = "green"
  }))


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "green-server"
    }
  }
}

resource "aws_autoscaling_group" "green_asg" {
  # availability_zones = ["${var.aws_region}a"]
  # instead of the above, use variable from vpc_zone_identifier
  # availability_zones  = [data.aws_subnet.private_b.availability_zone]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [data.aws_subnet.private_a.id]

  launch_template {
    id      = aws_launch_template.green_template.id
    version = "$Latest"
  }
}
