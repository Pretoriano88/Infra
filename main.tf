terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "infra_key_pair" {
  key_name   = var.key_name
  public_key = file("C:/Users/Praetorian/.ssh/infra.pub")
}

