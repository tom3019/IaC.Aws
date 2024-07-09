output "bucket_arn" {
    value = try(module.evertrust_terraform.aws_s3_bucket_arn,null)
    description = "bucket arn"
}

output "tags" {
  value =  try(module.evertrust_terraform.tags, null)
  description = "tags of bucket"
}