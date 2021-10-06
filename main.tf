terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.61.0"
    }
  }
}

provider "aws" {
  region = var.region
}


# Create a VPC
resource "aws_vpc" "rds-vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.envName}_rds-vpc"
  }
}

/*resource "aws_default_subnet" "rds_default_az1" {
  availability_zone = "ap-south-1"
}*/

resource "aws_subnet" "rds-pub-subnet" {
  vpc_id            = aws_vpc.rds-vpc.id
  availability_zone = var.azs[0]
  cidr_block        = var.subnetCidrs[0]

  tags = {
    Name = "${var.envName}_rds-pub-subnet"
  }
}

resource "aws_subnet" "rds-priv-subnet1" {
  vpc_id            = aws_vpc.rds-vpc.id
  availability_zone = var.azs[1]
  cidr_block        = var.subnetCidrs[1]

  tags = {
    Name = "${var.envName}_rds-priv-subnet1"
  }
}

resource "aws_subnet" "rds-priv-subnet2" {
  vpc_id            = aws_vpc.rds-vpc.id
  availability_zone = var.azs[2]
  #availability_zone = {var.azs[1], var.azs[2]}
  cidr_block        = var.subnetCidrs[2]

  tags = {
    Name = "${var.envName}_rds-priv-subnet2"
  }
}

resource "aws_internet_gateway" "rds-gw" {
  vpc_id = aws_vpc.rds-vpc.id

  tags = {
    Name = "${var.envName}_rds-gw"
  }
}

resource "aws_route_table" "rds_pub_rt" {
  vpc_id = aws_vpc.rds-vpc.id

  tags = {
    Name = "${var.envName}_rds-pub-rt"
  }
}

resource "aws_route" "rds_r" {
  route_table_id         = aws_route_table.rds_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rds-gw.id
}

resource "aws_route_table_association" "rds-rta" {
  subnet_id      = aws_subnet.rds-pub-subnet.id
  route_table_id = aws_route_table.rds_pub_rt.id
}

resource "aws_security_group" "rds-sg" {
  name        = "allow_ssh_http"
  description = "Allows port 22 and 80"
  vpc_id      = aws_vpc.rds-vpc.id
}

resource "aws_security_group_rule" "rds-sg-ig-ssh" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-sg.id
}

resource "aws_security_group_rule" "rds-sg-ig-http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-sg.id
}

resource "aws_security_group_rule" "rds-sg-eg-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-sg.id
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 10
  engine                 = "oracle"
  engine_version         = "12.2"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = "oracle"
  password               = "oracle123"
  parameter_group_name   = "oracle-ee-12.2"
  skip_final_snapshot    = true
  #vpc_security_group_ids = [aws_security_group.rds-sg.id]
  #db_subnet_group_name   = aws_subnet.rds-pub-subnet.id
  #db_subnet_group_name   = aws_subnet.rds-priv-subnet2.id
  #availability_zone=
  #option_group_name=
  #multi_az=
}