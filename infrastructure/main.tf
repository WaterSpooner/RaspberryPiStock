terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    backend "s3" {
    bucket         = "terraform-state-e55c417d-a006-4f81-a667-c1a2d320a0ce"
    key            = "notifier/state"
    region         = "eu-west-2"
  }
}

provider "aws" {
    region = "eu-west-2"
}