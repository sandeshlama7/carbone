################################################################################
# Local input variables
################################################################################

locals {
  bucket_arn = coalesce(var.bucket_arn, "arn:${data.aws_partition.this.partition}:s3:::${var.bucket}")

  # Convert from "arn:aws:sqs:eu-west-1:835367859851:bold-starling-0" into "https://sqs.eu-west-1.amazonaws.com/835367859851/bold-starling-0" if queue_id was not specified
  # queue_url used in aws_sqs_queue_policy is not the same as arn which is used in all other places
  queue_ids = { for k, v in var.sqs_notifications : k => format("https://%s.%s.amazonaws.com/%s/%s", data.aws_arn.queue[k].service, data.aws_arn.queue[k].region, data.aws_arn.queue[k].account, data.aws_arn.queue[k].resource) if try(v.queue_id, "") == "" }
}
