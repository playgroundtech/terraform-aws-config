![terratest](https://github.com/playgroundcloud/terraform-aws-config/workflows/terratest/badge.svg)
![terraform fmt](https://github.com/playgroundcloud/terraform-aws-config/workflows/terraform-fmt/badge.svg)
![terraform validate](https://github.com/playgroundcloud/terraform-aws-config/workflows/terraform-validate/badge.svg)
# Terraform AWS Config

This module sets up AWS Config, and a s3 bucket for historical configuration changes.
Also have the option to set up config on all regions or multiple regions via the aggregator resource.
With the aggregator resource you also have the ability to set up multi accounts, and even organization wide if you have the permissions.  
Read more about data aggregation in the [aws docs](https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html).

![image](./test/picture/config.png)

## Provisional Instructions

#### Minimal

```hcl
module "test" {
  source  = "playgroundtech/config/aws"
  version = "1.0.0"
  s3_bucket_name = "unique-name-of-your-s3-bucket"
}
```

#### With account aggregator

```hcl
module "account_aggregation" {
  source  = "playgroundtech/config/aws"
  version = "1.0.0"
  s3_bucket_name    = "unique-name-of-your-s3-bucket"
  create_aggregator = true
  account_aggregation_source = ({
    account_ids = ["123456789101"]
    all_regions = false
    regions     = ["eu-north-1","eu-west-1"]
  })
}

```

#### With organization aggregator

```hcl
module "organization_aggregation" {
  source  = "playgroundtech/config/aws"
  version = "1.0.0"
  s3_bucket_name    = "unique-name-of-your-s3-bucket"
  create_aggregator = true
  organization_aggregation_source = ({
    all_regions = true
    regions     = null
    role_arn    = module.organization_aggregation.aws_config_role_arn
  })
}

```
#### With already existing bucket

```hcl
module "existing_bucket" {
  source  = "playgroundtech/config/aws"
  version = "1.0.0"
  s3_bucket_name    = var.s3_bucket_name
  create_bucket     = false

  create_aggregator = true
  account_aggregation_source = ({
    account_ids = ["123456789101"]
    all_regions = true
    regions     = null
  })
}

```

### Variables:

- `s3_bucket_name` | (Required) - String  
  S3 bucket name to store AWS logs in.

- `versioning` | (Optional) - Bool  
  Enable versioning on s3 bucket.  
  Default: true

- `create_bucket` | (Optional) - Bool  
  Set to true to create a new bucket or to use an existing one to send logs to.  
  Default: true

- `config_delivery_frequency` | (Optional) - String  
  How often config will send snapshots to S3 bucket vpc endpoints.  
  Default: "Six_Hours"  
  Valid Values: One_Hour | Three_Hours | Six_Hours | Twelve_Hours | TwentyFour_Hours

- `standard_transition_days` | (Optional) - Number  
  Number of days to persist in the standard storage tier before moving to the infrequent access tier.  
  Default: 30

- `glacier_transition_days` | (Optional) - Number  
  Number of days after which to move the data to the glacier storage tier  
  Default: 60

- `enable_glacier_transition` | (Optional) - Bool  
  Enables the transition to AWS Glacier which can cause unnecessary costs for huge amount of small files  
  Default: true

- `expiration_days` | (Optional) - Number  
  Number of days after which to expunge the objects  
  Default: 90

- `config_name` | (Optional) - String  
  The name of the aws config instance  
  Default: "aws_config"

- `s3_tags` | (Optional) - Map(String)  
  Map tags to be used on s3 bucket  
  Default: {}

- `agg_tags` | (Optional) - Map(String)  
  Map tags to be used on aggregation resource  
  Default: {}

- `create_aggregator` | (Optional) - Bool  
  Enable this to aggregate with either account or organization source. If set to true, `account_aggregation_source` or `organization_aggregation_source` must also be set.  
  Default: false

- `account_aggregation_source` | (Optional) - Object

  - `account_ids` = `list(string)`   
    A list of all account IDs.  
  - `all_regions` = `bool`  
    If true, aggregate existing AWS Config regions and future regions. Conflicts with `regions`.  
  - `regions` = `list(string)`  
    List of source regions to be aggregated. Conflicts with `all_regions`    

  Object of account sources to aggregate. Either `regions` or `all_regions` must be specified.  
  If used, `create_aggregator` must be set to true.  
  If `all_regions` is set to true, `regions` must be null.    
  Default: Null  
  [Look at this example](./test/example_account_aggregation/main.tf)

- `organization_aggregation_source` | (Optional) - Object

  - `all_regions` = `bool`  
    If true, aggregate existing AWS Config regions and future regions. Conficts with `regions`.
  - `regions` = `list(string)`  
    List of source regions being aggregated. Conficts with `all_regions`
  - `role_arn` = `string`   
    The role arn with organization permissions.
    EG "service-role/AWSConfigRoleForOrganizations"

  Object with the AWS Organization configuration for the Config Aggregator. Either `regions` or `all_regions` must be specified.  
  If used, `create_aggregator` must be set to true.   
  If `all_regions` is set to true, `regions` must be null.
  Default: Null  
  [Look at this example](./test/example_organization_aggregation/main.tf)  
  
  
- `config_role_name` | (Optional) - String  
  The name of the config role.  
  _Default: "config_role"_

- `config_iam_policy_name` | (Optional) - String  
  The name of the config role policy.  
  _Default: "allow_s3_policy_to_config_role"_
  
### Outputs

- `aws_logs_bucket_arn`
- `aws_config_role_arn`
- `aws_config_role_name`
- `aws_config_role_id`
