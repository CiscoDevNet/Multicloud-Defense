output "mgmt_vpc_id" {
  value = google_compute_network.mgmt_network.self_link
}

output "datapath_vpc_id" {
  value = google_compute_network.datapath_network.self_link
}

output "vpc_id" {
  value = google_compute_network.datapath_network.self_link
}

output "mgmt_subnet_id" {
  value = google_compute_subnetwork.mgmt_subnet.self_link
}

output "datapath_subnet_id" {
  value = google_compute_subnetwork.datapath_subnet.self_link
}

output "mgmt_security_group" {
  value = tolist(google_compute_firewall.mgmt_ingress.target_tags)[0]
}

output "datapath_security_group" {
  value = tolist(google_compute_firewall.datapath_ingress.target_tags)[0]
}
