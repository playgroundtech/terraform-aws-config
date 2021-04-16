provider "aws" {
  region = "eu-north-1"

}

module "account_aggregation" {
  source            = "../../"
  s3_bucket_name    = "unique-name-of-your-s3-bucket"
  create_aggregator = true
  account_aggregation_source = ({
    account_ids = ["123456789101"]
    all_regions = false
    regions     = ["eu-north-1"]
  })
}

