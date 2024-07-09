output "arn" {
    value = module.evertrust_terraform.aws_s3_bucket_arn
    description = "The Arn of bucket"
}

output "id" {
    value = module.evertrust_terraform.aws_s3_bucket_id
    description = "value of bucket id"
}