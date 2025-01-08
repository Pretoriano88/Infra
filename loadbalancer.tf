# Load Balancer
resource "aws_lb" "example" {
  name               = "wordpress-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sc_loadballancer.id]
  subnets            = [aws_subnet.sub_public_a.id, aws_subnet.sub_public_b.id]
}

# Target Group
resource "aws_lb_target_group" "tg_lb" {
  name     = "wordpress-load-balancer"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher = "200-499"

  }
}

# Auto Scaling Group Attachment
resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.tg_lb.arn
}

# Listener
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_lb.arn
  }
}
