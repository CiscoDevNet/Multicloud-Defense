resource "google_compute_firewall" "datapath_ingress" {
  name          = "${var.prefix}-datapath-ingress"
  network       = google_compute_network.datapath_network.self_link
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-datapath"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "datapath_egress" {
  name               = "${var.prefix}-datapath-egress"
  network            = google_compute_network.datapath_network.self_link
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["${var.prefix}-datapath"]
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "mgmt_ingress" {
  name          = "${var.prefix}-mgmt-ingress"
  network       = google_compute_network.mgmt_network.self_link
  direction     = "INGRESS"
  source_ranges = [var.mgmt_cidr]
  target_tags   = ["${var.prefix}-mgmt"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "mgmt_egress" {
  name               = "${var.prefix}-mgmt-egress"
  network            = google_compute_network.mgmt_network.self_link
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["${var.prefix}-mgmt"]
  allow {
    protocol = "all"
  }
}
