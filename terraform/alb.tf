module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  # version = "9.11.0"

  name = local.alb.name
  #   load_balancer_type = local.alb.load_balancer_type
  vpc_id   = local.alb.vpc_id
  subnets  = local.alb.subnets
  internal = local.alb.internal

  listeners = {
    http = {
      port     = local.alb.http_tcp_listeners.port
      protocol = local.alb.http_tcp_listeners.protocol
      forward = {
        target_group_key = "carbone"
        action_type      = "forward"
      }
    }
  }

  target_groups = {
    carbone = {
      # name             = local.alb.target_groups.name
      protocol         = local.alb.target_groups.protocol
      port             = local.alb.target_groups.port
      target_type      = local.alb.target_groups.target_type
      create_attachment = false
      health_check = {
        enabled = true
        interval = 60
      }
    }
  }
  create_security_group = false
  security_groups       = local.alb.security_groups
}