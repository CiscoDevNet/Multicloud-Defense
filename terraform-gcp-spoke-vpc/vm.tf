locals {
  user_data = <<EOF
#! /bin/bash
curl -o /tmp/setup.sh https://raw.githubusercontent.com/maskiran/sample-web-app/main/ubuntu/setup_app.sh
bash /tmp/setup.sh &> /tmp/setup.log
EOF
}

resource "google_compute_instance" "vm" {
  # vms_list  [ {az_name: us-east1-a, vm_name: vm_az0_vm0}, ...]
  # convert this to a map of vm names, so i can dynamically change number of vms per zone later on
  for_each     = { for vm_details in local.vms_list : vm_details.vm_name => vm_details }
  name         = each.key
  machine_type = var.instance_type
  zone         = each.value.az_name
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }
  network_interface {
    network    = google_compute_network.spoke_vpc.self_link
    subnetwork = google_compute_subnetwork.spoke_subnet.self_link
    access_config {
    }
  }
  metadata = {
    subnet = google_compute_subnetwork.spoke_subnet.name
    prefix = var.prefix
  }
  metadata_startup_script = local.user_data
}
