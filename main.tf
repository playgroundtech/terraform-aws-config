resource "aws_s3_bucket" "aws_logs" {
  count         = var.create_bucket == false ? 0 : 1
  bucket        = var.s3_bucket_name
  acl           = "log-delivery-write"
  force_destroy = true

  tags = var.s3_tags
  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = var.standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.enable_glacier_transition ? [1] : []

      content {
        days          = var.glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.expiration_days
    }
  }
}

###############  CONFIG  ###############
resource "aws_config_delivery_channel" "config_DC" {
  name           = var.config_name
  s3_bucket_name = aws_s3_bucket.aws_logs.bucket
  sns_topic_arn  = aws_sns_topic.sns_config.arn
  depends_on     = [aws_config_configuration_recorder.conf_recorder]
  snapshot_delivery_properties {
    delivery_frequency = var.config_delivery_frequency
  }
}

resource "aws_config_configuration_recorder" "conf_recorder" {
  name     = var.config_name
  role_arn = aws_iam_role.config_role.arn
}

resource "aws_config_configuration_recorder_status" "conf_recorder_status" {
  name       = aws_config_configuration_recorder.conf_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_DC]
}

###############  POLICYS  ###############

resource "aws_iam_role" "config_role" {
  name               = "config_role"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_iam_policy" "allow_s3_policy" {
  name        = "allow_s3_policy_to_config_role"
  description = "Policy which allows the config role s3:* permissions."
  path        = "/"
  policy      = data.aws_iam_policy_document.data_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_service_role" {
  role       = aws_iam_role.config_role.name
  policy_arn = format("arn:%s:iam::aws:policy/service-role/AWS_ConfigRole", data.aws_partition.current.partition)
}

resource "aws_iam_role_policy_attachment" "attach_s3_policys" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.allow_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "organization" {
  count      = var.organization_aggregation_source != null ? 1 : 0
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}
