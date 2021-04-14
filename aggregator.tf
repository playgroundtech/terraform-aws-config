resource "aws_config_configuration_aggregator" "this" {
  count = var.create_aggregator ? 1 : 0
  name  = "${var.config_name}-aggregator-role"
  tags  = var.agg_tags

  dynamic "account_aggregation_source" {
    for_each = var.account_aggregation_source != null ? [var.account_aggregation_source] : []
    content {
      account_ids = account_aggregation_source.value.account_ids
      all_regions = account_aggregation_source.value.all_regions
      regions     = account_aggregation_source.value.regions
    }
  }

  dynamic "organization_aggregation_source" {
    for_each = var.organization_aggregation_source != null ? [var.organization_aggregation_source] : []
    content {
      all_regions = organization_aggregation_source.value.all_regions
      regions     = organization_aggregation_source.value.regions
      role_arn    = organization_aggregation_source.value.role_arn
    }
  }
}