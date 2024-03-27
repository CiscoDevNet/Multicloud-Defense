variable "project_id" {
  description = "Project Id"
  default     = ""
}

variable "ciscomcd_egress_gw_endpoint" {
  description = "ciscomcd Egress Gateway Endpoint (IP Address)"
}

variable "ciscomcd_service_vpc_id" {
  description = "ciscomcd Datapath Service VPC Id (self_link)"
}

variable "spoke_vpc_id" {
  description = "Spoke VPC Id (self_link) that needs to be peered with ciscomcd Service VPC"
}
