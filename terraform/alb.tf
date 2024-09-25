module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name                       = local.alb.name
  vpc_id                     = local.alb.vpc_id
  subnets                    = local.alb.subnets
  internal                   = local.alb.internal
  enable_deletion_protection = local.alb.enable_deletion_protection

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn
      forward = {
        target_group_key = "carbone"
      }
    }
    http = {
      port     = local.alb.http_tcp_listeners.port
      protocol = local.alb.http_tcp_listeners.protocol
      redirect = {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  target_groups = {
    carbone = {
      name        = local.alb.target_groups.name
      protocol    = local.alb.target_groups.protocol
      port        = local.alb.target_groups.port
      target_type = local.alb.target_groups.target_type
      health_check = {
        enabled  = true
        interval = 30
      }
      create_attachment = false
    }
  }
  create_security_group = false
  security_groups       = local.alb.security_groups
}