terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  tmp_cmps_svpc = split("/", var.ciscomcd_service_vpc_id)
  svpc_name = element(local.tmp_cmps_svpc, length(local.tmp_cmps_svpc)-1)
  tmp_cmps_spoke = split("/", var.spoke_vpc_id)
  spoke_vpc_name = element(local.tmp_cmps_spoke, length(local.tmp_cmps_spoke)-1)
}

