terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "dileep-tf-state-bucket-9284"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
    profile        = "dileep-tf"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "dileep-tf"
}
