output "intance_arn" {
  value = aws_instance.aws_instance_moudle.arn
  description = "The Arn of instance"
}

output "intance_id" {
  value = aws_instance.aws_instance_moudle.id
  description = "The Id of instance"
}
