data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

# get bucket arn from s3_bucket_name, don't query if create_bucket is false
data "aws_s3_bucket" "aws_logs" {
  count  = var.create_bucket == false ? 1 : 0
  bucket = var.s3_bucket_name
}

# process bucket arn 
locals {
  bucket_arn = var.create_bucket == true ? aws_s3_bucket.aws_logs[0].arn : data.aws_s3_bucket.aws_logs[0].arn
  bucket_id = var.create_bucket == true ? aws_s3_bucket.aws_logs[0].id : data.aws_s3_bucket.aws_logs[0].id
}

data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "aws_config_built_in_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

data "aws_iam_policy_document" "data_policy" {
  statement {
    sid       = "1"
    actions   = ["s3:*"]
    resources = [local.bucket_arn, "${local.bucket_arn}/*"]
  }
}
