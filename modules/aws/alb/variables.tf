#================================alb==============================================
variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "internal" {
  type = bool
  description = "value of true indicates that the load balancer is internal, and value of false indicates that the load balancer is internet-facing. The default is false."
}

variable "subnets" {
  type = list(string)
  description = "A list of subnet IDs to attach to the LB"
}

variable "security_groups" {
  type = list(string)
  description = "A list of security group IDs to assign to the LB"
}

variable "tags" {
  type = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {}
}

variable "project" {
  type = string
  description = "project"
}

#================================target group==============================================

variable "target_group_info" {
  description = "port:1~65535 ; protocol:HTTP、HTTPS、TCP、UDP、TLS、TCP_UDP、GENEVE"
  type = object({
    name = string
    port     = number
    protocol = string
  })
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "health_check" {
  description = "health_check配置，protocol:TCP、HTTP、HTTPS"
  type = object({
    port       = number
    protocol   = string //TCP、HTTP、HTTPS
    timeout    = number //2–120 秒
    interval   = number //5~300，預設30，間隔時間
    healthy_threshold   = number//健康域值，2-10。預設為 3，在考慮目標健康之前所需的連續健康檢查成功次數
    unhealthy_threshold = number//不健康域值，2-10，預設為 3，在考慮目標不健康之前所需的連續健康檢查失敗次數
  })
}


variable "target_instance_ids" {
  description = "instance id列表"
  type        = list(string)
}

#================================listeners==============================================

variable "listeners_info" {
  type = list(object({
    port     = number
    protocol = string
    rules = list(object({
      is_default = bool
      priority = number
      action_type = string
      redirect =  list(object({
        protocol = string
        port = number
        status_code = string
      }))
      forward = bool
      fixed_response = list(object({
        status_code = string
        content_type = string
      }))
      host_header_condition = string
    }))
  }))
  default = [ {
    port = 80
    protocol = "HTTP"
    rules = [ {
      is_default = false
      priority = 1
      action_type = "forward"
      redirect = [{
        protocol = "HTTPS"
        port = 443
        status_code = "HTTP_301"
      }]
      forward = false
      fixed_response = [{
        status_code = "200"
        content_type = "text/plain"
      }]
      host_header_condition = "www.example.com"
    } ]
  } ]
}
