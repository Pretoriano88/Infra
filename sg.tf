resource "aws_security_group" "sc_ec2" {
  name        = "SG EC2 "
  description = "Allow ssh EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-EC2"
  }
}

resource "aws_security_group" "sc_loadballancer" {
  name        = "SG LB "
  description = "Allow HTTP  all internet "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "LB HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http_node"
  }
}
resource "aws_security_group" "sc_autoscalling" {
  name        = "SG AutoScalling"
  description = "Allow SSH, HTTP Autoscalling "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    security_groups = [ aws_security_group.sc_loadballancer.id ]
    

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http_node"
  }
}

resource "aws_security_group" "sc_rdp" {
  name        = "SG RDP"
  description = "Allow mysql 3306 to autoscalling"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "RDS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sc_autoscalling.id]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http_node"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "SG EFS "
  description = "2049 open vpc"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block] # Usando o CIDR da VPC
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Efs_SG"
  }
}
resource "aws_security_group" "ec2_docker" {
  name   = "ec2_docker"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "PVT_Instance"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_docker_SG"
  }
}

resource "aws_security_group" "pritunl_sg" {
  name        = "pritunl-sg"
  description = "Security group for Pritunl VPN Server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.myip}/32"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myip}/32"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Pritunl_SG}"
  }
}

resource "aws_security_group" "memcached_sg" {
  name        = "memcached-security-group"
  description = "Security group for Memcached"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    security_groups = [ aws_security_group.sc_rdp.id ]
  }

  // Regra de saída para permitir todo o tráfego
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // Permite todo o tráfego
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Memcached_SG"
  }
}