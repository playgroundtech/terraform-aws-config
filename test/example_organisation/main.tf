provider "aws" {
  region = "eu-north-1"

}

module "organization_aggregation" {
  source            = "../../"
  s3_bucket_name    = "uniquenameofyours3bucket123"
  create_aggregator = true
  organization_aggregation_source = ({
    all_regions = true
    regions     = null
    role_arn    = module.organization_aggregation.aws_config_role_arn
  })
}

