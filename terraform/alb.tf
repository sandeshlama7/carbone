module "alb" {
  source = "./modules/elb"

  name               = local.alb.name
  load_balancer_type = local.alb.load_balancer_type
  vpc_id             = local.alb.vpc_id
  subnets            = local.alb.subnets
  internal           = local.alb.internal

  http_tcp_listeners = [{
    port               = local.alb.http_tcp_listeners.port
    protocol           = local.alb.http_tcp_listeners.protocol
    target_group_index = local.alb.http_tcp_listeners.target_group_index
    }
  ]

  target_groups = [{
    name             = local.alb.target_groups.name
    backend_protocol = local.alb.target_groups.protocol
    backend_port     = local.alb.target_groups.port
    target_type      = local.alb.target_groups.target_type
    }
  ]

  create_security_group = false
  security_groups       = local.alb.security_groups
}