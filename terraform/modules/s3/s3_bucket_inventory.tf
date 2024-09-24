######################################
# Bucket inventory configuration
######################################

resource "aws_s3_bucket_inventory" "this" {
  for_each = { for k, v in var.inventory_configuration : k => v if local.create_bucket }

  name                     = each.key
  bucket                   = try(each.value.bucket, aws_s3_bucket.this[0].id)
  included_object_versions = each.value.included_object_versions
  enabled                  = try(each.value.enabled, true)
  optional_fields          = try(each.value.optional_fields, null)

  destination {
    bucket {
      bucket_arn = try(each.value.destination.bucket_arn, aws_s3_bucket.this[0].arn)
      format     = try(each.value.destination.format, null)
      account_id = try(each.value.destination.account_id, null)
      prefix     = try(each.value.destination.prefix, null)

      dynamic "encryption" {
        for_each = length(try(flatten([each.value.destination.encryption]), [])) == 0 ? [] : [true]

        content {

          dynamic "sse_kms" {
            for_each = each.value.destination.encryption.encryption_type == "sse_kms" ? [true] : []

            content {
              key_id = try(each.value.destination.encryption.kms_key_id, null)
            }
          }

          dynamic "sse_s3" {
            for_each = each.value.destination.encryption.encryption_type == "sse_s3" ? [true] : []

            content {
            }
          }
        }
      }
    }
  }

  schedule {
    frequency = each.value.frequency
  }

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(each.value.filter.prefix, null)
    }
  }
}
