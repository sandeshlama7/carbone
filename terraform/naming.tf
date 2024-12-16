module "naming" {
  source         = "./modules/naming"
  aws_region     = local.region
  app_name       = local.project
  app_name_short = local.project_short
  environment    = local.environment
  project_prefix = local.project_prefix
}
