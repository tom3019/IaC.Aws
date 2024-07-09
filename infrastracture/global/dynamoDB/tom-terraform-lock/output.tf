output "arn" {
  value       = aws_dynamodb_table.terraform_locks.arn
  description = "The Arn of dynamodb table"
}

output "id" {
  value       = aws_dynamodb_table.terraform_locks.id
  description = "value of dynamodb table id"
}