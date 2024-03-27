# GCP App VPC

1. Create a VPC and a Subnet
1. Create a VM in each of the zones
1. Add ingress firewall rule to allow 80 and 443 from 0.0.0.0/0
1. Add ingress firewall rule to allow ssh from the current ip
1. Add egress firewall rule to allow all traffic out
1. Add a route to go the internet for the current ip (This is added in case you want to set a different default route via firewall instances etc)

## Variables

* `prefix` - Prefix used for all the resources, default `kiran-app`
* `region` - GCP Region, default `us-east1`
* `zones` - Availability zones in the above region, default `us-east1-b`
* `subnet_cidr` - Subnet CIDR, defaults to `10.0.0.0/24`
* `external_ips` - List of IPs for which the SSH access is enabled (used in the ssh ingress firewall rule), by default add the current IP. These are the additional IPs
* `instance_type` - Instance type of the VM, default `e2-medium`
* `vm_count_per_zone` - Number of VM instances per Zone, default 1
* `project_id` - Project Id in which the resources are created. When this repo is used as a module, the root module must define the project and it's inherited. This is required only if this module is run as root

## Outputs

* `vms` - A list of VMs, each item is a map, with all the details of the map
  ```
  [
    {
      "console_url" = "gcp console url for the vm"
      "name" = "vm-name"
      "private_ip" = "10.0.0.2"
      "public_ip" = "public-ip"
      "ssh_cmd" = [
        "ssh public-ip",
        "gcloud compute ssh --zone <zone-name> <vm-name> --project <project-name>",
      ]
      "subnet" = "subnet-name"
      "vpc" = "vpc-name"
      "zone" = "zone-name"
    },
  ]
  ```
* `vpc` - VPC object details
  ```
  {
    "cidr" = "10.0.0.0/24"
    "console_url" = "gcp console url for the vpc"
    "id" = "vpc-id"
    "name" = "vpc-name"
    "subnet" = {
      "cidr" = "10.0.0.0/24"
      "id" = "subnet-id"
      "name" = "subnemt-name"
      "region" = "us-east1"
    }
  }
  ```

## Running as a root module

```
git clone https://github.com/maskiran/terraform-gcp-app-vpc.git
cd terraform-gcp-app-vpc
mv provider provider.tf
cp values-sample values
```

## Using in another module

Create a tf file with the following content

```hcl
terraform {
  required_providers {
    gcp = {
      source = "hashicorp/gcp"
    }
  }
}

provider "gcp" {
  project = "my-gcp-project"
}

module "app_vpc" {
  source            = "github.com/maskiran/terraform-gcp-app-vpc"
  prefix            = "kiran-app"
  region            = "us-east1"
  zones             = ["us-east1-b", "us-east1-c"]
  subnet_cidr       = "10.0.0.0/24"
  external_ips      = []
  instance_type     = "e2-medium"
  vm_count_per_zone = 1
}
```

You can use variables instead of hard coded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
