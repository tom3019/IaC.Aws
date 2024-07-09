output "aws_s3_bucket_arn" {
  value       = try(var.prevent_destroy ? aws_s3_bucket.this[0].arn : aws_s3_bucket.can_destroy_bucket[0].arn, null)
  description = "The Arn of bucket"
}

output "aws_s3_bucket_id" {
  value       = try(var.prevent_destroy ? aws_s3_bucket.this[0].id : aws_s3_bucket.can_destroy_bucket[0].id, null)
  description = "value of bucket id"
}

output "tags" {
  value =  try(var.prevent_destroy ? aws_s3_bucket.this[0].tags_all : aws_s3_bucket.can_destroy_bucket[0].tags_all, null)
  description = "tags of bucket"
}