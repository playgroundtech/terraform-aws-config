# terraform-aws-config
This module sets up AWS Config and an s3 bucket for historical configuration changes.
Also have the option to setup config on all regions or mutiple regions via the aggregator resource.
With the aggregator resource you also have the ability to setup multi accounts, and even oraganisation wide if you have the persmissions.

![image](./test/picture/config.PNG)

## Provisional Instructions

#### Minimal
```hcl
module "test" {
  source = "git@github.com:playgroundcloud/terraform-aws-config.git?ref=vX.Y.Z"
  s3_bucket_name = "unique_name_of_your_s3_bucket"
}
```

#### With account aggregator
```hcl
module "account_aggregation" {
  source            = "git@github.com:playgroundcloud/terraform-aws-config.git?ref=vX.Y.Z"
  s3_bucket_name    = "unique_name_of_your_s3_bucket"
  create_aggregator = true
  account_aggregation_source = ({
    account_ids = ["12345678910"]
    all_regions = false
    regions     = ["eu-north-1","eu-west-1"]
  })
}

```

#### With orgaisation aggregator
```hcl
module "organization_aggregation" {
  source            = "git@github.com:playgroundcloud/terraform-aws-config.git?ref=vX.Y.Z"
  s3_bucket_name    = "unique_name_of_your_s3_bucket"
  create_aggregator = true
  organisation_aggregation_source = ({
    all_regions = true
    regions     = null
    role_arn    = module.organization_aggregation.aws_config_role_arn
  })
}

```


### Variables:

- `s3_bucket_name` | (Required) - String   
  S3 bucket name to store AWS logs in. 
  

- `s3_bucket_acl` | (Optional) - String    
  Set bucket ACL   
  Default: log-delivery-write
   

- `versioning` | (Optional) - Bool   
  Enable versioning on s3 bucket.   
  Default: false 
  

- `config_delivery_frequency` | (Optional) - String   
  How often config will send snapshots to S3 bucket vpc endpoints.     
  Default: "Six_Hours"

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

- `config_name` | (Optional) - string      
  The name of the aws config instance      
  Default: "aws_config"

- `tags` | (Optional) - map(string)      
  Map tags to be used on s3 bucket and aggregator      
  Default: {}

- `create_aggregator` | (Optional) - Bool      
  Enable this to aggregate with either account or organisation source. Also choose regions or all regions      
  Default: false

- `account_aggregation_source` | (Optional) - Object   
    >object({   
    account_ids = list(string)   
    all_regions = bool   
    regions = list(string)  
  })      

  Default: Null    
  (create_aggregator must be true to be able to aggregate)
- `organization_aggregation_source` | (Optional) - Object      
    >object({   
    all_regions = bool  
    regions     = list(string)  
    role_arn    = string   
    }) 

  Default: Null    
  (create_aggregator must be true to be able to aggregate)





### Outputs

- `aws_logs_bucket`
- `aws_config_role_arn`
- `aws_config_role_name`