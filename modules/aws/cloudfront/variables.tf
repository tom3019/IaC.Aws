variable "origin_domain_name" {
  description = "The domain name of the origin"
  type        = string
}

#origin Name
variable "origin_id" {
  description = "The name of the origin"
  type        = string
}

variable "origin_typ" {
  description = "s3、elb、api gateway、custom domain"
  type    = string
  default = "custom domain"
}

#public-s3允許公眾存取
#origin access control settings-Bucket 只能限制對 CloudFront 的存取。
variable "origin_access" {
  description = "若origin_typ為s3，請輸入 public 或 origin access control settings"
  type    = string
  default = "none"
}

#http-only、https-only、match-viewer
variable "origin_protocol_policy" {
  description = "http-only、https-only、match-viewer"
  type        = string
}

#TLSv1.2、TLSv1.1、TLSv1、SSLv3
variable "origin_ssl_protocols" {
  description = "TLSv1.2、TLSv1.1、TLSv1、SSLv3"
  type        = list(string) 
}

#cloudfront discription
variable "comment" {
  description = "The cloudfront of the discription"
  type        = string
  default = ""
}

#Maximum HTTP version to support on the distribution
variable "http_version" {
  description = "http1.1、http2、http2and3、http3"
  type        = string
}

#Whether Origin Shield is enabled
variable "enabled" {
  description = "true or false"
  type        = bool
}

#CloudFront 處理哪些 HTTP 方法並將其轉送到您的 Amazon S3 儲存桶或您的自訂來源
variable "allowed_methods" {
  description = "GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE"
  type        = list(string) 
}

#自動壓縮物件
variable "compress" {
  description = "true or false"
  type        = bool
  default     = false
}


variable "headers" {
  description = "希望 CloudFront 針對此快取行為進行變更的標頭"
  type        = list(string)
  default     = []
}



#Enable custom error response configuration
variable "enable_custom_error_response" {
  description = "true or false"
  type        = bool
  default     = false
}

variable "custom_error_responses" {
  description = "若enable_custom_error_response為true，需填寫此設定，List of custom error response configurations"
  type        = list(object({
    error_code            = number
    response_code         = number
    error_caching_min_ttl = number
  }))
  default     = []
}

variable "iam_certificate_id" {
  description = "iam_certificate"
  type        = string
}


#希望CloudFront用於HTTPS連線的SSL協定的最低版本
variable "minimum_protocol_version" {
  description = "TLSv1.2_2019、TLSv1.2_2021、預設:TLSv1"
  type        = string
}

variable "cloudfront_tags" {
  description = "Tags for the cloudfront"
  type        = map(string)
  default     = {}
}






