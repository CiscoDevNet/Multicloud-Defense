output "vpc" {
  value = {
    vpc_id : aws_vpc.ciscomcd_svpc.id
    vpc_name : aws_vpc.ciscomcd_svpc.tags.Name
  }
}

output "datapath_subnet" {
  value = { for idx, zone in var.zones :
    zone => {
      subnet_id : aws_subnet.datapath[idx].id
      subnet_name : aws_subnet.datapath[idx].tags.Name
      route_table_id : aws_route_table.datapath[idx].id
      route_table_name : aws_route_table.datapath[idx].tags.Name
    }
  }
}

output "mgmt_subnet" {
  value = { for idx, zone in var.zones :
    zone => {
      subnet_id : aws_subnet.mgmt[idx].id
      subnet_name : aws_subnet.mgmt[idx].tags.Name
      route_table_id : aws_route_table.mgmt[idx].id
      route_table_name : aws_route_table.mgmt[idx].tags.Name
    }
  }
}

output "tgw_attachment_subnet" {
  value = { for idx, zone in var.zones :
    zone => {
      subnet_id : aws_subnet.tgw_attachment[idx].id
      subnet_name : aws_subnet.tgw_attachment[idx].tags.Name
      route_table_id : aws_route_table.tgw_attachment[idx].id
      route_table_name : aws_route_table.tgw_attachment[idx].tags.Name
    }
  }
}

output "datapath_security_group" {
  value = {
    id : aws_security_group.datapath.id
    name : aws_security_group.datapath.name
  }
}

output "mgmt_security_group" {
  value = {
    id : aws_security_group.mgmt.id
    name : aws_security_group.mgmt.name
  }
}

output "ciscomcd_gw_instance_details" {
  description = "instance_details in ciscomcd_gateway resource"
  value = { for idx, zone in var.zones :
    zone => {
      availability_zone : zone
      mgmt_subnet : aws_subnet.mgmt[idx].id
      datapath_subnet : aws_subnet.datapath[idx].id
    }
  }
}
