terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.61.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAUTMASSMR3JCFH6XC"
  secret_key = "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"
}


# Create a VPC
resource "aws_vpc" "rds-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "rds-subnet-pub" {
  vpc_id     = aws_vpc.rds-vpc.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "rds-subnet-pub"
  }
}