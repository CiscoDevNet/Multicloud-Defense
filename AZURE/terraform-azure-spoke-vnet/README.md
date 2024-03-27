# Azure App VNet

1. Create a Resource Group
1. Create a VNet
1. Create a Subnet in the VNet
1. Create and associate a route table for the subnet
1. Add a default route to IGW in the subnet route table
1. Add a security group
1. Create a VM
1. Add inbound rule to allow 80 and 443 from 0.0.0.0/0
1. Add inbound rule to allow ssh from the current ip
1. Add outbound firewall rule to allow all traffic out
1. Add a route to go the internet for the current ip (This is added in case you want to set a different default route via firewall instances etc)

## Variables

* `prefix` - Prefix used for all the resources, default `kiran-app`
* `location` - AZure Location, default `eastus`
* `zones` - Availability zones in the above location, default `[1]`, (*This is not running properly, so not used in the module*)
* `vnet_cidr` - VNet CIDR, defaults to `10.0.0.0/16`
* `subnet_bits` - Additional bits to use for each of the subnets. Final subnet would be the mask of VPC CIDR + the value provided for this variable, default 8
* `ssh_public_key_file` - SSH Public Key File
* `instance_size` - Instance size of the VM, default `Standard_B1s`
* `vm_count_per_zone` - Number of VM instances per Zone, default 1
* `external_ips` - List of IPs for which the SSH access is enabled (used in the ssh ingress firewall rule), by default add the current IP. These are the additional IPs

## Outputs

* `vms` - A list of VMs, each item is a map, with all the details of the map
  ```
  [
    {
      "name" = "kiran-app-az0-vm0"
      "private_ip" = "10.0.0.4"
      "public_ip" = "<public_ip>"
      "security_group" = "kiran-app-sg"
      "ssh_cmd" = "ssh ubuntu@<public_ip>"
      "vpc" = "vnet-id"
      "vnet" = "vnet-id"
    },
  ]
  ```
* `vnet` - VNet object details
  ```
  {
    "cidr" = "10.0.0.0/16"
    "id" = "vnet-id"
    "name" = "kiran-app-vnet"
    "resource_group_name" = "kiran-app-rg"
    "subnet" = {
      "id" = "subnet-id"
      "name" = "kiran-app-subnet"
    }
  }
  ```

## Running as a root module

```
git clone https://github.com/maskiran/terraform-azure-app-vnet.git
cd terraform-azure-app-vnet
mv provider provider.tf
cp values-sample values
```

## Using in another module

Create a tf file with the following content

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

module "app_vnet" {
  source              = "github.com/maskiran/terraform-azure-app-vnet"
  prefix              = "kiran-app"
  location            = "eastus"
  zones               = ["1"]
  vnet_cidr           = "10.0.0.0/16"
  subnet_bits    = 8
  ssh_public_key_file = "sample.pub"
  instance_size       = "Standard_B1s"
  vm_count_per_zone   = 1
  external_ips        = []
}
```

You can use variables instead of hard coded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
