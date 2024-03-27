variable "prefix" {
  description = "Prefix for the resources created by this terraform"
  default     = "kiran-app"
}

variable "region" {
  description = "GCP Region where the subnets are created"
  default     = "us-east1"
}

variable "zones" {
  description = "Availability zones where the VMs are created"
  type        = list(string)
  default     = ["us-east1-b"]
}

variable "subnet_cidr" {
  description = "Spoke VPC CIDR"
  default     = "10.0.0.0/24"
}

variable "external_ips" {
  description = "IP Addresses for which Port 22 is opened in the Security Group"
  default     = []
  type        = list(string)
}

variable "instance_type" {
  description = "Instance Type/Size"
  default     = "e2-medium"
}

variable "vm_count_per_zone" {
  description = "Number of VM Instances per AZ"
  default     = 1
}

variable "project_id" {
  description = "Project Id in which the resources are created"
  default     = ""
}
