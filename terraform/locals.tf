locals {
  region   = var.region
  cidr_all = "0.0.0.0/0"

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
  vpc_id = local.vpc.create_vpc != true ? var.vpc_id : module.vpc.vpc_id
  public_subnets_id = local.vpc.create_vpc != true ? var.public_subnets_id : module.vpc.public_subnets
  private_subnets = local.vpc.create_vpc != true ? var.private_subnets_id : module.vpc.private_subnets

  ecs = {
    cluster_name = module.naming.resources.ecs-cluster.name
  }
}
