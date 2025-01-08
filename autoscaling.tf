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
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_attachment.this.autoscaling_group_name
  cooldown               = 300 //5
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_attachment.this.autoscaling_group_name
  cooldown               = 300 //5
}


resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold" // O alarme é acionado se a métrica for maior que o limite definido.
  evaluation_periods  = 2                      // Número de períodos de avaliação
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120       // Período em segundos
  statistic           = "Average" // A média das amostras no período de tempo
  threshold           = 80        // Limite de utilização da CPU em porcentagem

  alarm_description = "High CPU utilization alarm for EC2 instances"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_attachment.this.autoscaling_group_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_out_policy.arn]
  ok_actions      = [aws_autoscaling_policy.scale_in_policy.arn]
}