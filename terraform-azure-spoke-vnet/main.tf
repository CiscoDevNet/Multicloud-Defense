terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

data "azurerm_client_config" "current" {
}

# i dont know if this is the right way to get the current domain
data "azuread_domains" "current" {
  only_initial = true
}

locals {
  # prepare the list of vms per zone to look like a list of maps
  # [ {az_name: us-east-1a, vm_name: kiran-az0-vm0},
  #   {az_name: us-east-1a, vm_name: kiran-az0-vm1}
  #   {az_name: us-east-1b, vm_name: kiran-az1-vm0}
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
  # rearrange vms to a map by vm name
  # {
  #   kiran-az0-vm0 = {az_name: us-east-1a}
  #   kiran-az0-vm1 = {az_name: us-east-1a}
  #   kiran-az1-vm0 = {az_name: us-east-1b}
  #   kiran-az1-vm1 = {az_name: us-east-1b}
  # }
  vms_map = { for vm in local.vms_list : vm.vm_name => {
    az_name = vm.az_name
    }
  }

  myip = data.http.myip.response_body

  external_ips = sort(distinct(concat([local.myip], var.external_ips)))
}
