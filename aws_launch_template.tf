# Template de lançamento que especifica a configuração das instâncias EC2 WordPress
resource "aws_launch_template" "wordpress_lt" {
  name_prefix = "wordpress-lt"
  image_id    = var.ami

  instance_type = var.instance_type
  key_name      = var.key_name

  tag_specifications {
    resource_type = "instance"
    tags = {
      Application = "WordPress"
    }
  }


  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }


  network_interfaces {
    security_groups = [aws_security_group.sc_autoscalling.id]
  }

  user_data = base64encode(
    templatefile("${path.module}/scripts/wordpress.sh", {
      wp_db_name       = var.dbname,
      wp_username      = var.user,
      wp_user_password = var.password,
      wp_db_host       = aws_db_instance.this.address
      efs_dns_name     = aws_efs_file_system.foo.dns_name


    })
  )

}