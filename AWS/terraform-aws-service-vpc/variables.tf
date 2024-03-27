variable "zones" {
  description = "List of Availability Zone names where the ciscomcd Gateway instances are deployed"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "prefix" {
  description = "Prefix for the resources (vpc, subnet, route tables)"
  default     = "ciscomcd_svpc"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_bits" {
  description = "Number of additional bits in the subnet. The final subnet mask is the vpc_cidr mask + the value provided here"
  default     = 8
}

variable "region" {
  description = "(Optional) AWS region where Service VPC (and ciscomcd Gateways) are deployed. Required when running as root module"
  default     = "us-east-1"
}

