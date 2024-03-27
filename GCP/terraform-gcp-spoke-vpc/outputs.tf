output "vpc" {
  value = {
    name        = google_compute_network.spoke_vpc.name
    id          = google_compute_network.spoke_vpc.id
    cidr        = var.subnet_cidr
    console_url = "https://console.cloud.google.com/networking/networks/details/${google_compute_network.spoke_vpc.name}?project=${google_compute_network.spoke_vpc.project}"
    subnet = {
      name   = google_compute_subnetwork.spoke_subnet.name
      id     = google_compute_subnetwork.spoke_subnet.id
      region = var.region
      cidr   = var.subnet_cidr
    }
  }
}

output "vms" {
  value = [
    for instance in google_compute_instance.vm :
    {
      public_ip  = instance.network_interface.0.access_config.0.nat_ip
      private_ip = instance.network_interface.0.network_ip
      zone       = instance.zone
      ssh_cmd = [
        "ssh ${instance.network_interface.0.access_config.0.nat_ip}",
        "gcloud compute ssh --zone ${instance.zone} ${instance.name} --project ${instance.project}"
      ]
      name        = instance.name
      vpc         = google_compute_network.spoke_vpc.name
      subnet      = instance.metadata.subnet
      console_url = "https://console.cloud.google.com/compute/instancesDetail/zones/${instance.zone}/instances/${instance.name}?project=${instance.project}"
    }
  ]
}
