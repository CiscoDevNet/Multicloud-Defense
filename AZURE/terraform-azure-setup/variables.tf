variable "prefix" {
  description = "Prefix for all the resources created"
  default     = "ciscomcd"
}

variable "subscription_guids_list" {
  description = "List of subscription ids (guids) that are assigned the IAM role so they can be onboarded onto the ciscomcd Controller. If the list is empty the current default subscription is assumed. All the subscriptions must be under the same tenant (AD)"
  type        = list(string)
  default     = []
}
