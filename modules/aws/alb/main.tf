resource "aws_lb" "this" {
  name =  var.lb_name
  internal = var.internal
  load_balancer_type = "application"
  subnets = var.subnets
  security_groups = var.security_groups
  ip_address_type = "ipv4"
  
  tags = merge(
    var.tags,
    {
      Project      = var.project
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_info.name
  port        = var.target_group_info.port
  protocol    = var.target_group_info.protocol//HTTP、HTTPS、TCP、UDP、TLS、TCP_UDP、GENEVE
  target_type = "instance"
  vpc_id = var.vpc_id

  health_check {
    path                = "/health"
    port                = var.target_group_info.port//1和之間的有效端口號65536。或預值traffic-port.
    protocol            = var.health_check.protocol//TCP、HTTP、HTTPS
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval//5~300 預設30
  }
}

resource "aws_lb_target_group_attachment" "aws_lb_target_group_attachment_moudle" {
  count            = length(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.target_instance_ids[count.index]
}

locals {
  listeners = flatten([
    for idx,listener in var.listeners_info : [
      for rule_idx, rule_value in listener.rules :
        rule_value.is_default == true ? {
          action = {
            port = listener.port
            redirect = try(rule_value.redirect,[])
            forward = try(rule_value.forward,false)
            fixed_response =try(rule_value.fixed_response,[])
          }
        }:null
        if rule_value.is_default == true
      ]
    ])
}

resource "aws_lb_listener" "listener" {
  count = length(local.listeners)
  load_balancer_arn = aws_lb.this.arn
  port = local.listeners[count.index].action.port
  #redirect
  dynamic "default_action" {
    for_each = [for item in local.listeners[count.index].action.redirect : item if item != null ]
    content {
      type             = "redirect"
      target_group_arn = aws_lb_target_group.target_group.arn
      redirect {
        port        = default_action.value.port
        protocol    = default_action.value.protocol
        status_code = default_action.value.status_code
      }
    }
  }

  dynamic "default_action" {
     for_each =  local.listeners[count.index].action.forward ? [1] : []
     content {
       type = "forward"
       forward {
         target_group {
           arn = aws_lb_target_group.target_group.arn
           weight = 1
         }
       }
     }
  }

  dynamic "default_action" {
    for_each = [for item in local.listeners[count.index].action.fixed_response : item if item != null]
    content {
      type = "fixed-response"
      fixed_response {
        content_type = default_action.value.content_type
        status_code = default_action.value.status_code
      }
      
    }
  
  }

  tags = merge(
    var.tags,
    {
      Project      = var.project
      ManagedBy = "Terraform"
    }
  )

}

locals {
  listener_rules = flatten([
    for idx, listener in var.listeners_info : [
      for rule_idx, rule_value in listener.rules :
        rule_value.is_default == false ? {
          listener_arn = aws_lb_listener.listener[idx].arn
          priority     = rule_value.priority
          condition    = {
            host_header = {
              values = [rule_value.host_header_condition]
            }
          }
          action       = {
            type            = rule_value.action_type
            redirect        = try(rule_value.redirect,[])
            forward         = try(rule_value.forward,false)
            fixed_response  = try(rule_value.fixed_response,[])
          }
      }: null
      if rule_value.is_default != true
    ]
  ])
}

resource "aws_lb_listener_rule" "listener_rule" {
  count = length(local.listener_rules)
  listener_arn = local.listener_rules[count.index].listener_arn

  priority =  local.listener_rules[count.index].priority
  condition {
    host_header {
      values = local.listener_rules[count.index].condition.host_header.values
    }
  }

  dynamic "action" {
    for_each =  [for item in local.listener_rules[count.index].action.redirect : item if length(item) > 0]
    content {
      type = "redirect"
      redirect {
          port = action.value.port
          protocol = action.value.protocol
          status_code = action.value.status_code
      }
    }
  }

  dynamic "action" {
    for_each = local.listener_rules[count.index].action.forward ? [1] : []
    content {
      type = "forward"
      forward {
        target_group {
          arn = aws_lb_target_group.target_group.arn
          weight = 1
        
        }
      }
      
    }
  }

  dynamic "action" {
    for_each = [for item in local.listener_rules[count.index].action.fixed_response : item if length(item) > 0]
    content {
      type = "fixed-response"
      fixed_response {
          content_type = action.value.content_type
          status_code = action.value.status_code
      }
    }
    
  }

  tags = merge(
    var.tags,
    {
      Project      = var.project
      ManagedBy = "Terraform"
    }
  )

}