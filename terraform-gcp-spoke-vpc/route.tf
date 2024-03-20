resource "google_compute_route" "internet_route" {
  count            = length(local.external_ips)
  name             = "${var.prefix}-internet-ip-${count.index}"
  dest_range       = local.external_ips[count.index]
  network          = google_compute_network.spoke_vpc.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 900
}
