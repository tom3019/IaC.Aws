terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }

  required_version = ">=1.6.5"
  backend "s3" {
    bucket         = "tom-terraform-backend"
    key            = "global/dynamoDB/tom-terraform-lock/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tom-terraform-lock"
    encrypt        = true
    insecure       = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile          = "ohf"
    assume_role = {
      role_arn    = "arn/S_Terraform_Role"
      policy_arns = ["arn/S_Terraform_Role-policy"]
    }
  }
}

provider "aws" {
  region   = "ap-northeast-1"
  insecure = true
  profile = "ohf"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tom-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    ManagedBy = "Terraform"
  }
}