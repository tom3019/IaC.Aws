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
    key            = "global/s3/tom-terraform-backend/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tom-terraform-backend-lock"
    encrypt        = true
    insecure       = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile = "tom-profile"
    assume_role = {
      role_arn = "arn/S_Terraform_Role"
      policy_arns = ["arn/S_Terraform_Role-policy"]
    }
  }
}

provider "aws" {
  region   = "ap-northeast-1"
  insecure = true
  profile = "tom-profile"
}

module "evertrust_terraform" {
  source               = "git::ssh://gitrepo//modules/aws/s3?ref=0.0.6"
  s3_bucket_name       = "tom-terraform-backend"
  s3_bucket_versioning = true
}