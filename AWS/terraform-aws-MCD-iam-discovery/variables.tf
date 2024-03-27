variable "prefix" {
  description = "prefix for resources created in this template"
}

variable "controller_aws_account_number" {
  description = "this is the ciscomcd provided aws account number"
}

variable "ExternalId" {
  description = "this is the External ID shown on the Add AWS Account on mcd UI"
  default     = "ciscomcd"
}

variable "region" {
  description = "this is the aws region"
}

variable "s3_bucket" {
  description = "Create S3 Bucket where you want to store cloudtrail, route53 query logs and vpc flow logs"
}

variable "deployment_name" {
  description = "ciscomcd Controller deployment name"
  default     = "prod1"
}
