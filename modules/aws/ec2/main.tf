resource "aws_instance" "aws_instance_moudle" {
  ami           = var.aws_ami_id
  instance_type = var.instance_type
  key_name      = "ohfkey"
  subnet_id = var.aws_subnet_id
  security_groups = var.aws_security_groups_id
  associate_public_ip_address = false

  ebs_block_device {
    device_name = var.device_name
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = merge(
    var.instance_tags,
    {
      Name      = var.aws_instance_name
      ManagedBy = "Terraform"
    }
  )
}


