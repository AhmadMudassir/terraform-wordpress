provider "aws" {
  region = var.region
}

resource "aws_vpc" "ahmad-vpc-terra" {
  cidr_block = var.vpc-cidr
  tags = {
    "Name" = "ahmad-vpc-terra"
    "owner" = "ahmad"
  }
}

resource "aws_internet_gateway" "ahmad-igw-terra" {  
    vpc_id = aws_vpc.ahmad-vpc-terra.id
    tags = {
        "Name" = "ahmad-igw-terra"
        "owner" = var.owner
    }
}

resource "aws_subnet" "ahmad-public-subnet-terra" {
  vpc_id = aws_vpc.ahmad-vpc-terra.id
  cidr_block = var.subnet-cidr
  tags = {
    "Name" = "ahmad-public-subnet-terra"
    "owner" = var.owner
  }
}

resource "aws_route_table" "ahmad-public-sub-rt-terra" {
  vpc_id = aws_vpc.ahmad-vpc-terra.id
  route {
    cidr_block = var.all-traffic-cidr
    gateway_id = aws_internet_gateway.ahmad-igw-terra.id
  }
  tags = {
    "Name" = "ahmad-public-sub-rt-terra"
    "owner" = var.owner
  }
}

resource "aws_route_table_association" "ahmad-subnet-association" {
  subnet_id = aws_subnet.ahmad-public-subnet-terra.id
  route_table_id = aws_route_table.ahmad-public-sub-rt-terra.id
}

resource "aws_security_group" "ahmad-sg-terra" {
  name = "Http and SSH"
  vpc_id = aws_vpc.ahmad-vpc-terra.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.all-traffic-cidr]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.all-traffic-cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.all-traffic-cidr]
  }

  tags = {
    "Name" = "ahmad-sg-terra"
    "owner" = var.owner
  }
}

resource "aws_instance" "ahmad-ec2-terra" {
  ami = var.ami
  instance_type = var.type
  key_name = var.keypair

  subnet_id = aws_subnet.ahmad-public-subnet-terra.id
  vpc_security_group_ids = [ aws_security_group.ahmad-sg-terra.id ]
  associate_public_ip_address = true

  user_data = file("user-data.sh")

  tags = {
    "Name" = "ahmad-ec2-terra"
    "owner" = var.owner
  }
}


