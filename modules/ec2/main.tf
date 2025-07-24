resource "aws_launch_template" "app" {
  name_prefix   = "${var.env}-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.instance_profile_name
  }
  user_data = base64encode(var.user_data)
  vpc_security_group_ids = [var.ec2_sg_id]
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.env}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [var.target_group_arn]
  tags = [
    {
      key                 = "Name"
      value               = "${var.env}-app"
      propagate_at_launch = true
    }
  ]
}

output "asg_name" {
  value = aws_autoscaling_group.app.name
}