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

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "data_policy" {
  statement {
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      "${aws_s3_bucket.aws_logs.arn}",
      "${aws_s3_bucket.aws_logs.arn}/*"
    ]
  }
}
