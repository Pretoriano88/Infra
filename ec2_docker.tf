
// ssh-keygen com esse comando será criada uma chave publica 

resource "aws_instance" "ec2_docker" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.sub_private_b.id
  security_groups = [aws_security_group.ec2_docker.id]
  user_data       = file("${path.module}/scripts/docker.sh")

  tags = {
    Name = "Docker"
  }



}