terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "node1-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "node1-1"
  }
}

resource "aws_instance" "node2-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "node2-1"
  }
}

resource "aws_instance" "node3-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "node3-1"
  }
}

resource "aws_instance" "driver1-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "driver1-1"
  }
}

resource "aws_instance" "driver2-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "driver2-1"
  }
}

resource "aws_instance" "driver3-1" {
  ami           = "ami-0ee02425a4c7e78bb"
  instance_type = "c6g.large"
  tags = {
    Name = "driver3-1"
  }
}
