provider "aws" {
  region = "eu-north-1"
}

module "test" {
  source                    = "../../"
  s3_bucket_name            = "uniquenameofyours3bucket"
}