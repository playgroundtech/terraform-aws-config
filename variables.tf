############ S3 VARIABLES ############ 
variable "s3_bucket_acl" {
  description = "Set bucket ACL"
  default     = "log-delivery-write"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket to store AWS logs in."
  type        = string
}

variable "versioning" {
  description = "Enable versioning on s3 bucket or not. default = false"
  type        = bool
  default     = false
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

variable "aggregate_to_multi_region" {
  type        = bool
  default     = false
  description = "enable config on multi-region/multi-account or not"
}

variable "list_of_regions" {
  type    = list(string)
  default = [""]
}

variable "list_of_account_ids" {
  type    = list(string)
  default = [""]
}

variable "tags" {
  type        = map(string)
  description = "map tags to be used when creating Security Group and vpc endpoints to that SG"
  default     = {}
}