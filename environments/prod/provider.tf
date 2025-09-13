terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "terraform-web-platform-state-prod-account"
    key    = "webapp/prod/terraform.tfstate"
    region = "us-east-1"
    use_lockfile  = true
  }
}

provider "aws" {
  region = "us-east-1"
}
