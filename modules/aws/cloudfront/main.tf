provider "aws" {
  region   = "ap-northeast-1"
  insecure = true
}


resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  count   = (var.origin_typ =="s3" && var.origin_access != "public")? 1 : 0
  comment = "${var.origin_id}"
}


resource "aws_cloudfront_distribution" "cloudfront_module" {

  dynamic origin {
    for_each = (var.origin_typ!="s3") ? ["custom_origin_config"] : []
    content {
    connection_attempts = 3 #選填預設3 =>CloudFront 嘗試連接到來源的次數
    connection_timeout  = 10 #選填預設10 =>CloudFront 嘗試建立與來源的連線時等待的秒數
    domain_name         = var.origin_domain_name #必填
    origin_id           = var.origin_id #必填

    #CloudFront 自訂來源設定資訊。如果需要 S3 來源，請使用origin_access_control_id或s3_origin_config代替
    custom_origin_config {
      http_port                = 80 #必填
      https_port               = 443 #必填 
      origin_keepalive_timeout = 5 #選填預設5
      origin_protocol_policy   = var.origin_protocol_policy #必填
      origin_read_timeout      = 30 #選填預設30
      origin_ssl_protocols = var.origin_ssl_protocols #必填
    }
    }
  }

  dynamic "origin" {
    for_each = (var.origin_typ=="s3") ? ["s3_origin_config"] : []

    content {
          connection_attempts = 3 #選填預設3 =>CloudFront 嘗試連接到來源的次數
          connection_timeout  = 10 #選填預設10 =>CloudFront 嘗試建立與來源的連線時等待的秒數
          domain_name         = var.origin_domain_name #必填
          origin_id           = var.origin_id #必填

      s3_origin_config {
        origin_access_identity = (var.origin_typ=="s3" && var.origin_access != "public") ? aws_cloudfront_origin_access_identity.s3_oai[0].cloudfront_access_identity_path : null
      }
    }
  }


  #discription
  comment      = var.comment
  http_version = var.http_version #發行版支援的最大 HTTP 版本，預設為http2
  enabled      = var.enabled  #必填 Origin Shield 是否啟用

#此發行版的預設快取行為
  default_cache_behavior {
    allowed_methods        = var.allowed_methods #必填
    cached_methods         = ["GET", "HEAD"] #必填(固定)
    compress               = var.compress #選填，預設false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = var.origin_id #必填
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all" #必填

    #CachingOptimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    #AllViewer
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
   
  }
  
  dynamic "custom_error_response" {
    for_each = var.enable_custom_error_response ? var.custom_error_responses : []
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  
#此發行版的SSL 配置
  viewer_certificate {
    cloudfront_default_certificate = false
    iam_certificate_id             = var.iam_certificate_id #必填
    minimum_protocol_version       = "TLSv1" #預設:TLSv1
    ssl_support_method             = "sni-only" #希望 CloudFront 如何處理 HTTPS 請求
  }

#此發行版的限製配置
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = merge(
    var.cloudfront_tags,
    {
        ManagedBy = "Terraform"
    }
   )
  
  

}