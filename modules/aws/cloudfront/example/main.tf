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

module "cloudfront_terraform_create" {
    source ="../"
    origin_domain_name="test.domain.com.tw"
    origin_id="test.domain.com.tw"
    origin_typ="custom domain"
    origin_access=""
    origin_protocol_policy="http-only"
    origin_ssl_protocols=["TLSv1.2"]
    comment="test"
    http_version="http2"
    enabled=true
    allowed_methods=["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    compress=false
    headers=["exampleHeader"]
    enable_custom_error_response = true
    custom_error_responses = [
    {
      error_code            = 400
      response_code         = 0
      error_caching_min_ttl = 60
    },
    {
      error_code            = 500
      response_code         = 0
      error_caching_min_ttl = 60
    }, 
  ]
    iam_certificate_id="iam_certificate_id"
    minimum_protocol_version="TLSv1.2_2021"
    cloudfront_tags={}


}