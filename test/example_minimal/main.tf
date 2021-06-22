provider "aws" {
  region = "eu-north-1"
}

module "test" {
  source         = "../../"
  s3_bucket_name = var.s3_bucket_name
}

output "aws_logs_bucket_id" {
  value = module.test.aws_logs_bucket_id
}