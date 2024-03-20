terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  # prepare the list of vms per zone to look like a list of maps
  # [ 
  #   {az_name: us-east-1a, vm_name: kiran-az0-vm0},
  #   {az_name: us-east-1a, vm_name: kiran-az0-vm1},
  #   {az_name: us-east-1b, vm_name: kiran-az1-vm0},
  #   {az_name: us-east-1b, vm_name: kiran-az1-vm1}
  # ]
  vms_list = flatten([
    for az_idx, az_name in var.zones : [
      for vm_idx in range(var.vm_count_per_zone) : {
        az_name = az_name
        vm_name = "${var.prefix}-az${az_idx}-vm${vm_idx}"
      }
    ]
  ])

  myip = data.http.myip.response_body

  external_ips = sort(distinct(concat([local.myip], var.external_ips)))
}
