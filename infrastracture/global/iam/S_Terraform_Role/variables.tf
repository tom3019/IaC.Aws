variable "users" {
  type = list(object({
    arn  = string
    name = string
  }))
}