resource "google_compute_firewall" "spoke_vpc_fw_ingress" {
  name          = "${var.prefix}-ingress-app"
  network       = google_compute_network.spoke_vpc.self_link
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "spoke_vpc_fw_ingress_ssh" {
  name          = "${var.prefix}-ingress-ssh"
  network       = google_compute_network.spoke_vpc.self_link
  source_ranges = local.external_ips
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "spoke_vpc_fw_egress" {
  name               = "${var.prefix}-egress"
  network            = google_compute_network.spoke_vpc.self_link
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
