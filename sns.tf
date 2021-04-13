data "aws_iam_policy_document" "sns-policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.config_role.arn]
    }
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.sns_config.arn]
  }
}

resource "aws_sns_topic" "sns_config" {
  name = var.config_name
}

resource "aws_sns_topic_policy" "sns_config" {
  arn    = aws_sns_topic.sns_config.arn
  policy = data.aws_iam_policy_document.sns-policy.json
}