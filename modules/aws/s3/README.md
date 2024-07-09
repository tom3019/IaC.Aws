# S3 bucket Module

## Usage

```hcl
module "evertrust_terraform" {
  source               = "git::ssh://gitrepo//modules/aws/s3?ref=0.0.6"
  s3_bucket_name       = "my-s3-bucket"
  s3_bucket_versioning = true
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
|s3_bucket_name|s3 bucket name | string | null | yes|
|s3_bucket_versioning | 開啟版本控制 | bool | true | no |
|s3_bucket_tags|tags | array | {} | no |
|prevent_destroy|是否可刪除s3 | bool|true|no|

## Outputs
| Name | Description |
|------|-------------|
|aws_s3_bucket_arn|s3 bucket arn|
|aws_s3_bucket_id|s3 bucket id |
|tags|tags |