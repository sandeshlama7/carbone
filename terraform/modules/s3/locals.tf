################################################################################
# Local input variables
################################################################################

locals {
  create_bucket = var.create_bucket

  create_bucket_acl = (var.acl != null && var.acl != "null") || length(local.grants) > 0

  attach_policy = var.attach_require_latest_tls_policy || var.attach_access_log_delivery_policy || var.attach_elb_log_delivery_policy || var.attach_lb_log_delivery_policy || var.attach_deny_insecure_transport_policy || var.attach_inventory_destination_policy || var.attach_deny_incorrect_encryption_headers || var.attach_deny_incorrect_kms_key_sse || var.attach_deny_unencrypted_object_uploads || var.attach_policy

  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
  grants               = try(jsondecode(var.grant), var.grant)
  cors_rules           = try(jsondecode(var.cors_rule), var.cors_rule)
  lifecycle_rules      = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
  intelligent_tiering  = try(jsondecode(var.intelligent_tiering), var.intelligent_tiering)
  metric_configuration = try(jsondecode(var.metric_configuration), var.metric_configuration)
}

# AWS Load Balancer access log delivery policy
locals {
  # List of AWS regions where permissions should be granted to the specified Elastic Load Balancing account ID ( https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy )
  elb_service_accounts = {
    us-east-1 = "127311923021"
    us-east-2 = "033677994240"
  }
}
