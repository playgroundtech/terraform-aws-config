resource "aws_iam_role" "aggregator" {
  count              = var.aggregate_to_multi_region ? 1 : 0
  name               = "${var.config_name}-aggregator-role"
  tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_config_configuration_aggregator" "account" {
  count = var.aggregate_to_multi_region ? 1 : 0
  name  = "${var.config_name}-aggregator-role"
  tags  = var.tags

  account_aggregation_source {
    account_ids = var.list_of_account_ids
    regions     = var.list_of_regions
  }
}