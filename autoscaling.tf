resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [aws_subnet.sub_public_a.id, aws_subnet.sub_public_b.id]
  launch_template {
    id = aws_launch_template.wordpress_lt.id

    version = "$Latest"
  }
}

// Autoscaling_policy
resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down"
  scaling_adjustment     = -1 # Reduz uma instância (contração)
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_attachment.this.autoscaling_group_name
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up"
  scaling_adjustment     = 1 # Adiciona uma instância (expansão)
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_attachment.this.autoscaling_group_name
  cooldown               = 300
}


