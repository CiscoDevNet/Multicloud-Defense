variable "prefix" {
  description = "Prefix for the resources created by this terraform"
  default     = "kiran-app"
}

variable "location" {
  description = "Azure Location/Region where the resources are created"
  default     = "eastus"
}

variable "zones" {
  description = "Availability zones"
  default     = ["1"]
}

variable "vnet_cidr" {
  description = "CIDR for the Service/Hub VNET"
  default     = "10.0.0.0/16"
}

variable "subnet_bits" {
  description = "Number of additional bits in the subnet. The final subnet mask is the vnet_cidr mask + the value provided here"
  default     = 8
}

variable "ssh_public_key_file" {
  description = "SSH Public Key contents file name"
  default     = "sample.pub"
}

variable "instance_size" {
  description = "Instance size of the VMs"
  default     = "Standard_B1s"
}

variable "vm_count_per_zone" {
  description = "Number of VM Instances per AZ"
  default     = 1
}

variable "external_ips" {
  description = "IP Addresses for which a Port 22 is opened in the Security Group. By default the current machines IP is added. These are the additional addresses"
  default     = []
  type        = list(string)
}
