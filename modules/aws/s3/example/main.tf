terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }

  required_version = ">=1.6.5"

}

provider "aws" {
  region   = "ap-northeast-1"
  insecure = true
}

module "evertrust_terraform" {
  source               = "../"
  s3_bucket_name       = "evertrust-s3-bucket-module-example"
  s3_bucket_versioning = true
  s3_bucket_tags = {
    Environment = "test"
    UseBy       = "Unit Test"
  }
  prevent_destroy = false
}