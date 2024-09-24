######################################
# Bucket policy configuration
######################################

resource "aws_s3_bucket_policy" "this" {
  count = local.create_bucket && local.attach_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.combined[0].json

  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]
}
