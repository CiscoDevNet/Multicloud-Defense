resource "google_compute_network" "mgmt_network" {
  name                    = "${var.prefix}-svpc-mgmt"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mgmt_subnet" {
  name          = "${var.prefix}-svpc-mgmt-subnet"
  ip_cidr_range = var.mgmt_cidr
  region        = var.region
  network       = google_compute_network.mgmt_network.self_link
}

resource "google_compute_network" "datapath_network" {
  name                    = "${var.prefix}-svpc-datapath"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "datapath_subnet" {
  name          = "${var.prefix}-svpc-datapath-subnet"
  ip_cidr_range = var.datapath_cidr
  region        = var.region
  network       = google_compute_network.datapath_network.self_link
}
