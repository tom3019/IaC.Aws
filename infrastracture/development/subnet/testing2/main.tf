terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.30.0"
    }
  }

  backend "s3" {
    bucket         = "evertrust-terraform"
    key            = "development/subnet/testing2/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "evertrust-terraform-lock"
    encrypt        = true
    insecure       = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile = "ohf"
    assume_role = {
      role_arn = "arn:aws:iam::178322424346:role/S_Terraform_Role"
      policy_arns = ["arn:aws:iam::178322424346:policy/S_Terraform_Role-policy"]
    }
  }

}

provider "aws" {
  region   = "ap-northeast-1"
  insecure = true
  profile  = "ohf"
}


data "terraform_remote_state" "ycvpn" {
  backend = "s3"
  config = {
    bucket   = "evertrust-terraform"
    key      = "global/vpc/ycvpn/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
  }
}

import {
  to = aws_subnet.testing2
  id = "subnet-1a00a343"
}

resource "aws_subnet" "testing2" {
  vpc_id                  = data.terraform_remote_state.ycvpn.outputs.vpc_id
  cidr_block              = "10.88.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "testing2"
    ManagedBy = "Terraform"
  }
}