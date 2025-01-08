resource "aws_db_instance" "this" {
  allocated_storage      = 10
  db_name                = var.dbname
  engine                 = var.engine
  engine_version         = var.v_engine
  instance_class         = var.db_class_instance
  username               = var.user
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.sc_rdp.id]
  multi_az               = var.multi_az
  port                   = var.port
  db_subnet_group_name   = aws_db_subnet_group.rds_sn_group.name


  # Certificando que as alterações manuais de senha rds sejam ignoradas
  lifecycle {
    ignore_changes = [password]
  }

}