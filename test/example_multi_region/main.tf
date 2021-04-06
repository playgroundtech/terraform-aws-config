provider "aws" {
  region = "eu-north-1"

}

module "test" {
  source                    = "../../"
  s3_bucket_name            = "uniquenameofyours3bucket"
  aggregate_to_multi_region = true
  list_of_regions           = ["eu-north-1", "eu-west-1"]
  list_of_account_ids       = ["127745533311"]
}

