terraform {
  required_version = ">=1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.30.0"
    }
  }
}

provider "aws" {
  insecure = true
  region   = "ap-northeast-1"
}

module "alb_sample" {
  source          = "../"
  project         = "tom_test"
  lb_name         = "tom-test-alb"
  internal        = false
  subnets         = ["subnet-id", "subnet-id"]
  security_groups = ["sg-id", "sg-id"]
  vpc_id          = "vpc-id"
  target_group_info = {
    name     = "tom-test-tg"
    port     = 80
    protocol = "HTTP"
  }
  health_check = {
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  target_instance_ids = ["i-id"]
  listeners_info = [
    {
      port     = 80
      protocol = "HTTP"
      rules = [
        {
          priority              = 1
          action_type           = "forward"
          is_default            = true
          forward               = true
          host_header_condition = "www.example.com"
          fixed_response        = []
          redirect              = []
        },
        {
          priority    = 2
          action_type = "redirect"
          is_default  = false
          redirect = [{
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }]
          forward               = false
          fixed_response        = []
          host_header_condition = "www.example.com"
        }
      ]


    },
    {
      priority = 1
      port     = 443
      protocol = "HTTPS"
      rules = [
        {
          priority    = 1
          action_type = "redirect"
          is_default  = true
          redirect = [{
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
          }]
          forward               = false
          fixed_response        = []
          host_header_condition = "www.example.com"
        },
        {
          priority              = 1
          action_type           = "forward"
          is_default            = false
          forward               = true
          host_header_condition = "www.example.com"
          fixed_response        = []
          redirect              = []
        }
      ]

    }
  ]
}