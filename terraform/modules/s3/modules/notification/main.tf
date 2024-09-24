################################################################################
# Defines the resources to be created
################################################################################

resource "aws_s3_bucket_notification" "this" {
  count = var.create ? 1 : 0

  bucket = var.bucket

  eventbridge = var.eventbridge

  dynamic "lambda_function" {
    for_each = var.lambda_notifications

    content {
      id                  = try(lambda_function.value.id, lambda_function.key)
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }

  dynamic "queue" {
    for_each = var.sqs_notifications

    content {
      id            = try(queue.value.id, queue.key)
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = try(queue.value.filter_prefix, null)
      filter_suffix = try(queue.value.filter_suffix, null)
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications

    content {
      id            = try(topic.value.id, topic.key)
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = try(topic.value.filter_prefix, null)
      filter_suffix = try(topic.value.filter_suffix, null)
    }
  }

  depends_on = [
    aws_lambda_permission.allow,
    aws_sqs_queue_policy.allow,
    aws_sns_topic_policy.allow,
  ]
}

# Lambda
resource "aws_lambda_permission" "allow" {
  for_each = var.lambda_notifications

  statement_id_prefix = "AllowLambdaS3BucketNotification-"
  action              = "lambda:InvokeFunction"
  function_name       = each.value.function_name
  qualifier           = try(each.value.qualifier, null)
  principal           = "s3.amazonaws.com"
  source_arn          = local.bucket_arn
  source_account      = try(each.value.source_account, null)
}
resource "aws_sqs_queue_policy" "allow" {
  for_each = { for k, v in var.sqs_notifications : k => v if var.create_sqs_policy }

  queue_url = try(each.value.queue_id, local.queue_ids[each.key], null)
  policy    = data.aws_iam_policy_document.sqs[each.key].json
}

resource "aws_sns_topic_policy" "allow" {
  for_each = { for k, v in var.sns_notifications : k => v if var.create_sns_policy }

  arn    = each.value.topic_arn
  policy = data.aws_iam_policy_document.sns[each.key].json
}
