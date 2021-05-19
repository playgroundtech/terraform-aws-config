provider "aws" {
  region = "eu-north-1"
}

data "aws_caller_identity" "current" {}

# represents your already existing s3 bucket

resource "aws_s3_bucket" "aws_logs" {
  bucket        = var.s3_bucket_name
  acl           = "log-delivery-write"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

module "test" {
  source         = "../../"
  config_name    = var.config_name
  s3_bucket_name = aws_s3_bucket.aws_logs.id
  create_bucket  = false

  create_aggregator = true
  account_aggregation_source = ({
    account_ids = [data.aws_caller_identity.current.account_id]
    all_regions = true
    regions     = null
  })

  depends_on = [
    aws_s3_bucket.aws_logs
  ]
}
