
# SNS - generic_topic_sns
resource "aws_sns_topic" "alerts_topic" {
  name = "alerts-topic"
}

# assginature SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.sns-email
}

# Alarme CPU para Auto Scaling Group (EC2)
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  alarm_description = "High CPU utilization alarm for EC2 instances"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_out_policy.arn]
  ok_actions      = [aws_autoscaling_policy.scale_in_policy.arn]
}

# Alarme CPU para RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization_alarm" {
  alarm_name          = "HighRDSCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  alarm_description = "High CPU utilization alarm for RDS instances"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.identifier
  }

  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  ok_actions    = [aws_sns_topic.alerts_topic.arn]
}

# Alarme Memória para RDS
resource "aws_cloudwatch_metric_alarm" "rds_memory_utilization_alarm" {
  alarm_name          = "LowRDSMemoryAvailable"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 50000000  # Exemplo: 50 MB de memória disponível

  alarm_description = "Low available memory alarm for RDS instances"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.identifier
  }

  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  ok_actions    = [aws_sns_topic.alerts_topic.arn]
}

# Alarme Memória para ElastiCache
resource "aws_cloudwatch_metric_alarm" "memcached_memory_utilization_alarm" {
  alarm_name          = "LowMemcachedMemoryAvailable"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = 120
  statistic           = "Average"
  threshold           = 10000000  # Exemplo: 10 MB de memória disponível

  alarm_description = "Low available memory alarm for ElastiCache"
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.cache_cluster.id
  }

  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  ok_actions    = [aws_sns_topic.alerts_topic.arn]
}

# Alarme Disponibilidade para Docker
resource "aws_cloudwatch_metric_alarm" "docker_ec2_instance_alarm" {
  alarm_name          = "DockerInstanceAvailability"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Maximum"
  threshold           = 1

  alarm_description = "Availability alarm for private EC2 instance running Docker"
  dimensions = {
    InstanceId = aws_instance.ec2_docker.id
  }

  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  ok_actions    = [aws_sns_topic.alerts_topic.arn]
}

# Alarme CPU para Pritunl
resource "aws_cloudwatch_metric_alarm" "pritunl_cpu_utilization_alarm" {
  alarm_name          = "HighPritunlCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  alarm_description = "High CPU utilization alarm for Pritunl instances"
  dimensions = {
    InstanceId = aws_instance.ec2_pritunl.id
  }

  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  ok_actions    = [aws_sns_topic.alerts_topic.arn]
}
