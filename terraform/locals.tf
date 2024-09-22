locals {
  region   = var.region
  cidr_all = "0.0.0.0/0"

  ecr_repo = split("/", "${module.ecr.repository_url}")[0]

  ##### Naming
  project        = var.project
  project_short  = var.project_short
  environment    = var.environment
  project_prefix = var.project_prefix

  ##### VPC

  vpc = {
    create_vpc           = var.vpc_id != "" && length(var.private_subnets_id) != 0 && length(var.public_subnets_id) != 0 ? false : true
    name                 = module.naming.resources.vpc.name
    cidr                 = var.vpc_cidr
    azs                  = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
    create_igw           = true
    enable_dns_hostnames = true
    enable_dns_support   = true
    enable_nat_gateway   = true
    single_nat_gateway   = true
    enable_flow_log      = false
    number_of_azs        = var.number_of_azs
  }
  vpc_id             = local.vpc.create_vpc != true ? var.vpc_id : module.vpc.vpc_id
  public_subnets_id  = local.vpc.create_vpc != true ? var.public_subnets_id : module.vpc.public_subnets
  private_subnets_id = local.vpc.create_vpc != true ? var.private_subnets_id : module.vpc.private_subnets

  ecs = {
    cluster_name          = module.naming.resources.ecs-cluster.name
    create_security_group = false
  }

  ecr = {
    repository_name = module.naming.resources.ecr.name
  }

  alb = {
    name               = module.naming.resources.alb.name
    vpc_id             = local.vpc_id
    subnets            = local.public_subnets_id
    load_balancer_type = "application"
    internal           = false
    enable_deletion_protection = false

    http_tcp_listeners = {
      port     = 80
      protocol = "HTTP"
    }

    target_groups = {
      name        = module.naming.resources.tg.name
      protocol    = "HTTP"
      port        = 4000
      target_type = "ip"
    }

    create_security_group = false
    security_groups       = [module.alb_sg.security_group_id]
  }

  sg = {
    alb = {
      name        = "${module.naming.resources.sg.name}-alb"
      description = "Security Group for the Application Load Balancer that allows all inbound HTTP and HTTPS traffic"
    }

    ecs = {
      name        = "${module.naming.resources.sg.name}-ecs-service"
      description = "Security Group for the ECS Service that allows inbound traffic on the container port from the ALB"
    }
  }

  efs = {
    name             = module.naming.resources.efs.name
    creation_token   = "${module.naming.resources.prefix.name}-efs-creation-token"
    encrypted        = true
    performance_mode = "generalPurpose"
    lifecycle_policy = {
      transition_to_ia = "AFTER_30_DAYS"
    }
    security_group_name        = "${module.naming.resources.sg.name}-efs"
    security_group_description = "Security Group for the EFS that allows inbound traffic from ECS Task"
  }

  acm = {
    validation_method = "DNS"
    wait_for_validation = true
  }

}
