locals {
  region   = var.region
  cidr_all = "0.0.0.0/0"

  ##### Naming
  project        = var.project
  project_short  = var.project_short
  environment    = var.environment
  project_prefix = var.project_prefix

  ##### VPC
  create_igw           = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_flow_log      = false

  vpc = {
    name = module.naming.resources.vpc.name
    cidr = var.vpc_cidr
    azs  = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  }
  number_of_azs = var.number_of_azs
}