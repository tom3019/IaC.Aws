resource "aws_s3_bucket" "this" {
  count = var.prevent_destroy ? 1 : 0
  bucket = var.s3_bucket_name
  tags = merge(
    var.s3_bucket_tags,
    {
      Name      = var.s3_bucket_name
      ManagedBy = "Terraform"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
  
}

resource "aws_s3_bucket" "can_destroy_bucket" {
  count = var.prevent_destroy ? 0 : 1
  bucket = var.s3_bucket_name
  tags = merge(
    var.s3_bucket_tags,
    {
      Name      = var.s3_bucket_name
      ManagedBy = "Terraform"
    }
  )
  
}

#新增版本控制
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = var.prevent_destroy ? aws_s3_bucket.this[0].id : aws_s3_bucket.can_destroy_bucket[0].id
  versioning_configuration {
    status = var.s3_bucket_versioning ? "Enabled" : "Suspended"
  }
}

#加密s3中的資料
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = var.prevent_destroy ? aws_s3_bucket.this[0].id : aws_s3_bucket.can_destroy_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = var.prevent_destroy ? aws_s3_bucket.this[0].id : aws_s3_bucket.can_destroy_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}