resource "google_compute_network" "spoke_vpc" {
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "spoke_subnet" {
  name          = "${var.prefix}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.spoke_vpc.self_link
}
