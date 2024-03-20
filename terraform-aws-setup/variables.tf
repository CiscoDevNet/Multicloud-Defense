variable "region" {
  description = "AWS Region, required only when being run as root module"
  default     = ""
}

variable "ciscomcd_api_key_file" {
  description = "ciscomcd API Key json file name downloaded from the ciscomcd Dashboard, required only when being run as root module"
  default     = ""
}

variable "deployment_name" {
  description = "ciscomcd Controller deployment name (ask ciscomcd)"
  default     = "prod1"
}

variable "prefix" {
  description = "Prefix for resources created in this template"
  default     = "ciscomcd"
}

variable "controller_aws_account_number" {
  description = "ciscomcd provided aws account number (ask ciscomcd)"
}

variable "s3_bucket" {
  description = "Create S3 Bucket to store CloudTrail, Route53 Query Logs and VPC Flow Logs"
  default     = ""
}

variable "object_duration" {
  description = "Duration (in days) after which the objects in the s3 bucket are deleted"
  default     = 1
}

variable "create_cloud_trail" {
  description = "Create a multi region CloudTrail and store the events in the s3_bucket. If you already have a CloudTrail, then provide this value as false"
  default     = true
  type        = bool
}

variable "aws_credentials_profile" {
  description = "AWS Credentials Profile Name, required only when run as root module"
  default     = ""
}

variable "ciscomcd_aws_cloud_account_name" {
  description = "Name used to represent this AWS Account on the ciscomcd Dashboard, if this is empty the AWS account is not added to the ciscomcd Controller"
  default     = ""
}

variable "inventory_regions" {
  description = "Regions that ciscomcd Controller can monitor and update the inventory for dynamic security policies: us-east-1, us-east-2"
  default     = []
  type        = list(string)
}
