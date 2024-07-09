output "arn" {
  value = aws_cloudfront_distribution.cloudfront_module.arn
  description = "The Arn of cloudfront" 
}


output "id" {
  value = aws_cloudfront_distribution.cloudfront_module.id
  description = "The id of cloudfront" 
}

output "domain_name" {
  value = aws_cloudfront_distribution.cloudfront_module.domain_name
  description = "The domain_name of cloudfront" 
}