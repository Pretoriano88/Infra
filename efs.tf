resource "aws_efs_file_system" "foo" {
  creation_token = "efs-system"

  tags = {
    Name = "efs system"
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}
resource "aws_efs_mount_target" "mount_target_private_a" {
  file_system_id  = aws_efs_file_system.foo.id
  subnet_id       = aws_subnet.sub_private_a.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount_target_private_b" {
  file_system_id  = aws_efs_file_system.foo.id
  subnet_id       = aws_subnet.sub_private_b.id
  security_groups = [aws_security_group.efs_sg.id]
}