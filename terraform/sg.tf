module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name        = local.sg.alb.name
  description = local.sg.alb.description
  vpc_id      = local.vpc_id

  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = [local.cidr_all]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = [local.cidr_all]

}

module "ecs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name        = local.sg.ecs.name
  description = local.sg.ecs.description
  vpc_id      = local.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 4000
      to_port                  = 4000
      protocol                 = 6
      description              = "Container exposing port 4000. Allow traffic from ALB"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = [local.cidr_all]

}