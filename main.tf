provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc_italo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.vpc_italo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.vpc_italo.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.vpc_italo.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.vpc_italo.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_instance" "webserver" {
  ami           = "ami-03295ec1641924349"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_a.id
}

resource "aws_db_instance" "banco" {
  allocated_storage = 10
  engine = "postgres"
  engine_version = "12.5"
  instance_class = "db.t2.micro"
  name = "banco1"
  username = "admini"
  password = "loki0506"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
}

resource "aws_db_subnet_group" "db_subnet" {
  name = "dbsubnet"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
}
