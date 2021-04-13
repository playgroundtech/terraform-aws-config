provider "aws" {
  region = "eu-north-1"

}

module "account_aggregation" {
  source            = "../../"
  s3_bucket_name    = "uniquenameofyours3bucket"
  create_aggregator = true
  account_aggregation_source = ({
    account_ids = ["127745533311"]
    all_regions = false
    regions     = ["eu-north-1"]
  })
}
