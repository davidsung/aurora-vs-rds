data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" { state = "available" }

data "aws_availability_zones" "primary" {
  all_availability_zones = true

  filter {
    name   = "zone-name"
    values = ["${data.aws_region.current.name}a"]
  }

  depends_on = [module.vpc]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
