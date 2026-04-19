# Provider configuration
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — keeps state safe and shared across the team
  backend "s3" {
    bucket         = "my-company-terraform-state"
    key            = "sre-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (staging or production)"
  type        = string
}

# Example resource: S3 bucket for logs
resource "aws_s3_bucket" "logs" {
  bucket = "my-company-${var.environment}-logs"

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Team        = "sre"
  }
}

# Enable versioning on the logs bucket
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
