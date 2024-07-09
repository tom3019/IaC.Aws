# S3 bucket Module

## Usage

```hcl
module "intance_terraform_create" {
    source = "git::ssh://gitrepo//modules/aws/ec2?ref=0.0.6"
    aws_instance_name="my_instance_name"
    aws_subnet_id="my_subnet_id"
    aws_security_groups=["my_security_groups_id", "my_security_groups_id2"]
    aws_ami="ami_id"
    instance_type="instance_type"
    device_name="/dev/sda1"   
    volume_type="gp2"
    volume_size=8
    instance_tags={terraform=true}
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.6.5 |
| aws | >=5.30.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >=5.30.0 |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|aws_instance_name|主機名稱 | string | null | yes|
|aws_subnet_id | subnet id | string  | null | yes |
|aws_security_groups | security groups id| array  | {} | yes |
|aws_ami| ami id | string | null | yes |
|instance_type| 規格 | string | null | yes |
|device_name| 磁碟路徑 | string | /dev/sda1 | no |
|volume_type| 磁碟類型 | string | gp2 | no |
|volume_size| 磁碟大小 | int | null | yes |
|instance_tags|tags | map | {} | no |

## Outputs
| Name | Description |
|------|-------------|
|intance_arn|intance arn|
|intance_id|intance id |