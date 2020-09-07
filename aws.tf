terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 3.0"
  region  = var.aws_region
}
