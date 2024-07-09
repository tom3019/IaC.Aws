# S3 bucket Module

## Usage

```hcl
module "intance_terraform_create" {
    source ="../../../../../Evertrust.Infrastracture.Modules/aws/modules/cloudfront"
    origin_domain_name="my_origin_domain"
    origin_id="my_origin_name"
    origin_typ="s3"
    origin_access="public"
    origin_protocol_policy="http-only"
    origin_ssl_protocols=["TLSv1.2","SSLv3"]
    comment="test"
    http_version="http2"
    enabled=true
    allowed_methods=["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    compress=false
    headers=[]
    query_string=false
    enable_custom_error_response = true
    custom_error_responses = [
    {
      error_code            = 400 
      response_code         = 0
      error_caching_min_ttl = 60 //輸入錯誤緩存最短生存時間 (TTL)（以秒為單位）
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
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.6.5 |
| aws | >=5.30.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >=5.30.0 |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|origin_domain_name | origin domain name | string | null | yes|
|origin_id | origin名稱 | string  | null | yes |
|origin_typ | origin類型<br>(可選s3、elb、api gateway、custom domain) | string | custom domain | yes |
|origin_access | origin access 若為s3，請輸入 public 或 origin access control settings | string | none | no |
|origin_protocol_policy | 協定 <br>(可選http-only、https-only、match-viewer)| string | null | yes |
|device_name | 最小來源 SSL 協定 <br>(可複選TLSv1.2、TLSv1.1、TLSv1、SSLv3)| array | null | yes |
|comment | cloudfront discription | string | null | no |
|http_version | 支援的 HTTP 版本 <br>(可複選http1.1、http2、http2and3、http3)| string | null | yes |
|enabled |Whether Origin Shield is enabled | bool | null | yes |
|allowed_methods |CloudFront 可處理哪些 HTTP 方法<br>(可複選GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE) | array | null | yes |
|compress | 自動壓縮物件 | bool | false | yes |
|headers | 希望 CloudFront 針對此快取行為進行變更的標頭 | array | null | no |
|enable_custom_error_response | 是否需 HTTP 錯誤代碼 | bool| null | yes |
|custom_error_responses | 若enable_custom_error_response為true，需填寫此設定 | array(object) | null | no |
|iam_certificate_id | iam certificate id | string | null | yes |
|minimum_protocol_version | HTTPS連線SSL協定的最低版本<br>(可選TLSv1.2_2019、TLSv1.2_2021、TLSv1) | string | null | yse |
|cloudfront_tags |tags | map | {} | no |

## Outputs
| Name | Description |
|------|-------------|
|arn|cloudfront arn|
|id|cloudfront id |
|domain_name|cloudfront domain_name |