variable "prefix" {
  description = "Prefix for all resources created in this VPC"
  default     = "kiran-app"
}

variable "region" {
  description = "AWS Region where resources are created. Required only when this is run as root module"
  default     = "us-east-1"
}

variable "zones" {
  description = "Availability Zones that will be used"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_bits" {
  description = "Number of additional bits (on top of the VPC CIDE mask) to use in the subnets inside VPC (final subnet would be the mask of vpc cidr + the value provided for this variable)"
  default     = 8
}

variable "vm_count_per_zone" {
  description = "Number of VM Instances per AZ"
  default     = 1
}

variable "key_name" {
  description = "SSH Keypair name"
}

variable "instance_type" {
  description = "Instance Type of VMs"
  default     = "t3a.medium"
}

variable "external_ips" {
  description = "IP Addresses for which a Port 22 is opened in the Security Group. By default the current machines IP is added. These are the additional addresses"
  default     = []
  type        = list(string)
}
