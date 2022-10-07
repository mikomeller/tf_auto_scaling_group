resource "aws_launch_template" "blue_template"{
    name = "blue-template"
    image_id = data.aws_ami.ubuntu_image.id
    instance_type = var.instance_type
    key_name = var.keypair
    vpc_security_group_ids = [aws_security_group.app_server.id]
    user_data = base64encode(templatefile("${path.module}/user-data.sh.tpl", {
        version = "Blue website", 
        color = "blue"
    }))

    tag_specifications {
      resource_type = "instance"

    tags = {
        Name = "blue-server"
    }
    }
}

resource "aws_autoscaling_group" "blue_asg" {
    # availability_zones = ["${var.aws_region}a"]
    # instead of the above, use variable from vpc_zone_identifier
    # availability_zones = [data.aws_subnet.private_a.availability_zones]
    desired_capacity = 2
    max_size = 2
    min_size = 1
    vpc_zone_identifier = [data.aws_subnet.private_a.id]

launch_template {
  id = aws_launch_template.blue_template.id
  version = "$Latest"
}
}
