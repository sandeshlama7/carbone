output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The Id of the VPC"
}
output "default_tags" {
  value       = module.naming.default_tags
  description = "The default tags provided by the naming module based on the input values"
}
output "efs_ap" {
  value = module.efs.access_points
}
output "domain_name" {
  value = module.route53_record.route53_record_name
}