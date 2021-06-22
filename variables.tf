############ S3 VARIABLES ############ 
variable "s3_bucket_name" {
  description = "S3 bucket name to store AWS logs in."
  type        = string
}

variable "create_bucket" {
  type        = bool
  description = "Set to true to create a new bucket or to use an existing one to send logs to."
  default     = true
}

variable "versioning" {
  description = "Enable versioning on s3 bucket"
  type        = bool
  default     = true
}

variable "config_delivery_frequency" {
  description = "How often config will send snapshots to S3 bucket"
  type        = string
  default     = "Six_Hours"
}

variable "standard_transition_days" {
  type        = number
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
}

variable "glacier_transition_days" {
  type        = number
  default     = 60
  description = "Number of days after which to move the data to the glacier storage tier"
}

variable "enable_glacier_transition" {
  type        = bool
  default     = true
  description = "Enables the transition to AWS Glacier which can cause unnecessary costs for huge amount of small files"
}

variable "expiration_days" {
  type        = number
  default     = 90
  description = "Number of days after which to expunge the objects"
}

############ CONFIG VARIABLES ############

variable "config_name" {
  type        = string
  default     = "aws_config"
  description = "The name of the aws config instance"
}


variable "s3_tags" {
  type        = map(string)
  description = "map tags to be used on s3 bucket"
  default     = {}
}

############ AGGREGATOR VARIABLES ############

variable "agg_tags" {
  type        = map(string)
  description = "map tags to be used on aggregator resource"
  default     = {}
}

variable "create_aggregator" {
  type        = bool
  default     = false
  description = "Enable this to aggregate with either account or organization source."
}

variable "account_aggregation_source" {
  description = "Object of account sources to aggregate. Either regions or all_regions must be specified. If used, create_aggregator must be set to true."
  type = object({
    account_ids = list(string)
    all_regions = bool
    regions     = list(string)
  })
  default = null
}

variable "organization_aggregation_source" {
  description = "Object with the AWS Organization configuration for the Config Aggregator. Either regions or all_regions must be specified. If used, create_aggregator must be set to true."
  type = object({
    all_regions = bool
    regions     = list(string)
    role_arn    = string
  })
  default = null
}

############ IAM VARIABLES ############

variable "config_role_name" {
  description = "The name of the config role"
  type        = string
  default     = "config_role"
}

variable "config_iam_policy_name" {
  description = "The name of the config role policy"
  type        = string
  default     = "allow_s3_policy_to_config_role"
}
