
// ssh-keygen com esse comando será criada uma chave publica 

resource "aws_instance" "ec2_pritunl" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.sub_public_b.id
  security_groups = [aws_security_group.pritunl_sg.id]
  user_data       = file("${path.module}/scripts/pritunl.sh")

  tags = {
    Name = "Pritunl"
  }
}