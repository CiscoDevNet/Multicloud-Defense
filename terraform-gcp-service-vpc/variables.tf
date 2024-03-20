variable "prefix" {
  description = "Prefix used for all the resources created"
  default     = "ciscomcd"
}

variable "project_id" {
  description = "Project Id"
  default     = ""
}

variable "region" {
  description = "Region Name"
  default     = "us-east1"
}

variable "mgmt_cidr" {
  description = "Mgmt Subnet CIDR"
  default     = "172.16.0.0/24"
}

variable "datapath_cidr" {
  description = "Datapath Subnet CIDR"
  default     = "172.16.1.0/24"
}
