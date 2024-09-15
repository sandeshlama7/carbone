module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = local.vpc.name
  create_vpc       = local.vpc.create_vpc
  cidr             = local.vpc.cidr
  azs              = local.vpc.azs
  private_subnets  = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k)]
  public_subnets   = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k + 2)]
  database_subnets = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.cidr, 4, k + 4)]

  # Gateways
  create_igw         = local.vpc.create_igw
  enable_nat_gateway = local.vpc.enable_nat_gateway
  single_nat_gateway = local.vpc.single_nat_gateway

  enable_dns_hostnames = local.vpc.enable_dns_hostnames
  enable_dns_support   = local.vpc.enable_dns_support

  #VPC Flow Log
  enable_flow_log = local.vpc.enable_flow_log
}
