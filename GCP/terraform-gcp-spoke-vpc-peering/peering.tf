resource "google_compute_network_peering" "datapath_to_spoke" {
  name         = "${local.svpc_name}-to-${local.spoke_vpc_name}"
  network      = var.ciscomcd_service_vpc_id
  peer_network = var.spoke_vpc_id
}

resource "google_compute_network_peering" "spoke_to_datapath" {
  name         = "${local.spoke_vpc_name}-to-${local.svpc_name}"
  network      = var.spoke_vpc_id
  peer_network = var.ciscomcd_service_vpc_id
}
