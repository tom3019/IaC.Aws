terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.30.0"
    }
  }
  
}

provider "aws" {
  region = "ap-northeast-1"
  insecure = true
}



data "terraform_remote_state" "subnet_testing1" {
  backend = "s3"
  config = {
    bucket   = "evertrust-terraform"
    key      = "development/subnet/testing1/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile = "ohf"
    assume_role = {
      role_arn = "arn:aws:iam::178322424346:role/S_Terraform_Role"
      policy_arns = ["arn:aws:iam::178322424346:policy/S_Terraform_Role-policy"]
    }
  }
}

data "terraform_remote_state" "security_groups_SG-Any-Private-outbound" {
  backend = "s3"
  config = {
    bucket   = "evertrust-terraform"
    key      = "global/security_group/SG-Any-Private-outbound/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile = "ohf"
    assume_role = {
      role_arn = "arn:aws:iam::178322424346:role/S_Terraform_Role"
      policy_arns = ["arn:aws:iam::178322424346:policy/S_Terraform_Role-policy"]
    }
  }
}

data "terraform_remote_state" "security_groups_SG-Any-Private-inbound" {
  backend = "s3"
  config = {
    bucket   = "evertrust-terraform"
    key      = "global/security_group/SG-Any-Private-inbound/terraform.tfstate"
    region   = "ap-northeast-1"
    encrypt  = true
    insecure = true
    #issue: https://github.com/hashicorp/terraform/issues/34053
    skip_s3_checksum = true
    profile = "ohf"
    assume_role = {
      role_arn = "arn:aws:iam::178322424346:role/S_Terraform_Role"
      policy_arns = ["arn:aws:iam::178322424346:policy/S_Terraform_Role-policy"]
    }
  }
}


module "intance_terraform_create" {
    source = "../"
    aws_instance_name="Sample_Terraform"
    aws_subnet_id=data.terraform_remote_state.subnet_testing1.outputs.id
    aws_security_groups_id=[data.terraform_remote_state.security_groups_SG-Any-Private-outbound.outputs.id, data.terraform_remote_state.security_groups_SG-Any-Private-inbound.outputs.id]
    aws_ami_id="ami-07c589821f2b353aa"
    instance_type="t2.micro"
    device_name="/dev/sda1"   
    volume_type="gp2"
    volume_size=8
    instance_tags={}
}