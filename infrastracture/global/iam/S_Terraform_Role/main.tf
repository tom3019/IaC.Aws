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
    key            = "global/iam/S_Terraform_Role/terraform.tfstate"
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

data "terraform_remote_state" "tom-terraform" {
  backend = "s3"
  config = {
    bucket   = "tom-terraform-backend"
    key      = "global/s3/tom-terraform-backend/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    assume_role = {
      role_arn = "arn/S_Terraform_Role"
      policy_arns = ["arn/S_Terraform_Role-policy"]
    }
  }
}

data "terraform_remote_state" "tom-terraform-lock" {
  backend = "s3"
  config = {
    bucket   = "tom-terraform-backend"
    key      = "global/dynamoDB/tom-terraform-lock/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    assume_role = {
      role_arn = "arn/S_Terraform_Role"
      policy_arns = ["arn/S_Terraform_Role-policy"]
    }
  }
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    effect = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [data.terraform_remote_state.tom-terraform.outputs.arn]
  }

  statement {
    effect = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${data.terraform_remote_state.tom-terraform.outputs.arn}/*"]
  }


  statement {
    effect = "Allow"
    actions   = ["dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:GetItem","dynamodb:DescribeTable"]
    resources = [data.terraform_remote_state.tom-terraform-lock.outputs.arn]
  }
}

resource "aws_iam_policy" "iam_policy" {
  name = "${aws_iam_role.this.name}-policy"
  path = "/"
  policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    ManagedBy     = "Terraform"
    ResourceGroup = "Terraform_Backend"
  }
}

data "aws_caller_identity" "current" {
  
}

resource "aws_iam_role" "this" {
  name               = "S_Terraform_Role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      for user in var.users : {
        "Effect"   : "Allow",
        "Principal": {
          "AWS": user.arn
        },
        "Action"   : "sts:AssumeRole",
        "Sid" : ""
      }
    ]
  })

  tags = {
    ManagedBy     = "Terraform"
    ResourceGroup = "Terraform_Backend"
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.iam_policy.arn
}



