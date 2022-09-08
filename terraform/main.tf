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
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "devopscodesacademyremotestate"
    key            = "infrastructure/eu-central-1/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "devopscodesacademy-tf-locks"
  }
}