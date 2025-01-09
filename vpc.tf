# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

}

// Subnets
resource "aws_subnet" "sub_private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1) # X.X..1.x/24
  availability_zone = "${var.region}a"



  tags = {
    Name = "Sub-private a"
  }
}

resource "aws_subnet" "sub_private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2) # X.X..2.x/24
  availability_zone = "${var.region}b"


  tags = {
    Name = "Sub-private b"
  }
}

resource "aws_subnet" "sub_public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 3) # X.X..3.x/24
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true


  tags = {
    Name = "Sub-public a"
  }
}
resource "aws_subnet" "sub_public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 4) # X.X.4.x/24
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true


  tags = {
    Name = "Sub-public b"
  }
}


//RDS subnet group

resource "aws_db_subnet_group" "rds_sn_group" {
  name       = "dbsubnet"
  subnet_ids = [aws_subnet.sub_private_a.id, aws_subnet.sub_private_b.id]

  tags = {
    Name = "Subnet group RDS"
  }
}

// IGW 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

// Nat Gateway
# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.sub_public_a.id
  tags = {
    Name = "Nat_Gateway"
  }
}

resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Public_Route_Table"
  }

}

//Elastic IP 

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "ElasticIP"
  }
}


# Create a route table for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id # Default rout to NAT Gateway
  }
  tags = {
    Name = "Private_Route_Table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.sub_public_a.id
  route_table_id = aws_route_table.Public_Route_Table.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.sub_public_b.id
  route_table_id = aws_route_table.Public_Route_Table.id
}


# Associate NAT route table with private subnet
resource "aws_route_table_association" "private_route_association_a" {
  subnet_id      = aws_subnet.sub_private_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_association_b" {
  subnet_id      = aws_subnet.sub_private_b.id
  route_table_id = aws_route_table.private_route_table.id
}

