terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

# EC2 Instance
resource "aws_instance" "sre_server" {
  ami                    = "ami-0ff290337e78c83bf"
  instance_type          = "t3.micro"
  key_name               = "sre-key"
  vpc_security_group_ids = [aws_security_group.sre_sg.id]

  tags = {
    Name        = "sre-staging-server"
    Environment = "staging"
    ManagedBy   = "terraform"
    Team        = "sre"
    UpdatedBy   = "ci-cd"
  }
}

# Elastic IP
resource "aws_eip" "sre_eip" {
  instance = aws_instance.sre_server.id
  domain   = "vpc"

  tags = {
    Name = "sre-staging-eip"
  }
}

# Security Group
resource "aws_security_group" "sre_sg" {
  name        = "sre-staging-sg-tf"
  description = "Security group for SRE staging server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "sre-staging-sg-tf"
    ManagedBy = "terraform"
  }
}
