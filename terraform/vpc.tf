module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = local.vpc.name
  create_vpc       = var.vpc_id != "" && length(var.private_subnets_id) != 0 && length(var.public_subnets_id) != 0 ? false : true
  cidr             = local.vpc.cidr
  azs              = local.vpc.azs
  private_subnets  = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k)]
  public_subnets   = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k + 2)]
  database_subnets = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k + 4)]

  # Gateways
  create_igw         = local.create_igw
  enable_nat_gateway = local.enable_nat_gateway
  single_nat_gateway = local.single_nat_gateway

  enable_dns_hostnames = local.enable_dns_hostnames
  enable_dns_support   = local.enable_dns_support

  #VPC Flow Log
  enable_flow_log = local.enable_flow_log
}
