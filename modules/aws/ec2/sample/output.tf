output "intance_arn" {
  value = module.intance_terraform_create.intance_arn
  description = "The Arn of instance"
}

output "intance_id" {
  value = module.intance_terraform_create.intance_id
  description = "The Id of instance"
} 