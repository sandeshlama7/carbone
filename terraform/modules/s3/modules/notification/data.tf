################################################################################
# data source
################################################################################
data "aws_partition" "this" {}

# SQS Queue
data "aws_arn" "queue" {
  for_each = var.sqs_notifications

  arn = each.value.queue_arn
}

data "aws_iam_policy_document" "sqs" {
  for_each = { for k, v in var.sqs_notifications : k => v if var.create_sqs_policy }

  statement {
    sid = "AllowSQSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.queue_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.bucket_arn]
    }
  }
}

# SNS Topic
data "aws_iam_policy_document" "sns" {
  for_each = { for k, v in var.sns_notifications : k => v if var.create_sns_policy }

  statement {
    sid = "AllowSNSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.topic_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.bucket_arn]
    }
  }
}
