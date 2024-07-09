# S3 bucket variables
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "s3_bucket_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "prevent_destroy" {
  description = "禁止刪除此bucket"
  type        = bool
  default     = true
}