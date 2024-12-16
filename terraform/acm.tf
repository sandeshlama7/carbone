# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> 4.0"

#   domain_name = values(module.route53_record.route53_record_name)[0]
#   zone_id     = data.aws_route53_zone.route53_zone.zone_id

#   validation_method = local.acm.validation_method

#   wait_for_validation = local.acm.wait_for_validation

# }
