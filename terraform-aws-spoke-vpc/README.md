# AWS App VPC

1. Create a VPC
1. Create Internet Gateway and attach to the VPC
1. Create a Subnet in each of the zones
1. Create and associate a route table for each of the subnets
1. Add a default route to IGW in the subnet route table
1. Add a security groups
1. Create a VM in each of the zones
1. Add ingress rule to allow 80 and 443 from 0.0.0.0/0
1. Add ingress rule to allow ssh from the current ip
1. Add egress firewall rule to allow all traffic out
1. Add a route to go the internet for the current ip (This is added in case you want to set a different default route via firewall instances etc)

## Variables

* `prefix` - Prefix used for all the resources, default `kiran-app`
* `zones` - Availability zones in the above region, default `us-east-1b`
* `vpc_cidr` - Subnet CIDR, defaults to `10.0.0.0/16`
* `subnet_bits` - Additional bits to use for each of the subnets. Final subnet would be the mask of VPC CIDR + the value provided for this variable, default 8
* `vm_count_per_zone` - Number of VM instances per Zone, default 1
* `key_name` - SSH Keypair Name
* `instance_type` - Instance type of the VM, default `t3a.medium`
* `external_ips` - List of IPs for which the SSH access is enabled (used in the ssh ingress firewall rule), by default add the current IP. These are the additional IPs
* `region` - AWS Region, default `us-east-1`. Required only when run as root module

## Outputs

* `vms` - A list of VMs, each item is a map, with all the details of the map
  ```
  [
    {
      "az" = "us-east-1b"
      "console_url" = "aws console url for the vm"
      "id" = "i-1111"
      "name" = "kiran-app-az0-vm0"
      "private_ip" = "10.0.0.10"
      "public_ip" = "public-ip"
      "ssh_cmd" = "ssh ubuntu@public-ip"
      "subnet" = "subnet-1234"
      "vpc" = "vpc-1234"
    },
  ]
  ```
* `vpc` - VPC object details
  ```
  {
    "cidr" = "10.0.0.0/16"
    "console_url" = "aws console url for the vpc"
    "id" = "vpc-1234"
    "igw_id" = "igw-1234"
    "name" = "kiran-app-vpc"
    "subnets" = [
      {
        "cidr_block" = "10.0.0.0/24"
        "console_url" = "aws console url for the subnet"
        "id" = "subnet-1234"
        "name" = "kiran-app-az0"
      },
    ]
  }
  ```

## Running as a root module

```
git clone https://github.com/maskiran/terraform-aws-app-vpc.git
cd terraform-aws-app-vpc
mv provider provider.tf
cp values-sample values
```

## Using in another module

Create a tf file with the following content

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "app_vpc" {
  source            = "github.com/maskiran/terraform-aws-app-vpc"
  prefix            = "kiran-app"
  region            = "us-east-1"
  zones             = ["us-east-1b", "us-east-1c"]
  vpc_cidr          = "10.0.0.0/24"
  subnet_bits       = 8
  vm_count_per_zone = 1
  key_name          = "keypair_name"
  instance_type     = "e2-medium"
  external_ips      = []
}
```

You can use variables instead of hard coded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
