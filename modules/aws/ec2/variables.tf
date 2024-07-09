variable "aws_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "aws_subnet_id" {
  description = "The id of the subnet"
  type        = string

}

variable "aws_security_groups_id" {
  description = "The id of the security_groups"
  type        = list(string)
  
}
variable "aws_ami_id" {
  description = "The id of the ami"
  type        = string
  
}

variable "instance_type" {
  description = "The name of the instance_type"
  type        = string
  
}

variable "device_name" {
  description = "The name of the device_name"
  type        = string
  default = "/dev/sda1"

}



variable "volume_type" {
  description = "The name of the volume_type"
  type        = string
  default = "gp2"
}

variable "volume_size" {
  description = "The size of the volume_size"
  type        = number
}

variable "instance_tags" {
  description = "Tags for the aws instance"
  type        = map(string)
  default     = {}
}



