# Service VPC for AWS using AWS terraform provider

Create a Multicloud-Defense Service VPC to deploy Multicloud-Defense Gateway.

1. Create a VPC
1. Create internet gateway and attach to the VPC
1. Create the following subnets in each of the availability zones:
    * datapath subnet and datapath route table associated to it, default route to igw
    * mgmt subnet and mgmt route table associated to it, default route to igw
    * tgw_attachment subnet and a route table associated to it
1. Create security groups in the VPC
    * datapath: allow all ingress and egress traffic
    * mgmt: allow all egress traffic
1. tgw_attachment subnet must be used to attach to the transit gateway
1. After the Multicloud-Defense Gateway is created in the VPC, add a default route in the tgw_attachment route table with next-hop as the gwlbe


## Variables
* `zones` - Availability zones, defaults to `["us-east-1a", "us-east-1b"]`
* `prefix` - Prefix used for all the resources created, defaults to `Multicloud-Defense_svpc`
* `vpc_cidr` - CIDR used for the VPC, defaults to `172.16.0.0/16`
* `vpc_subnet_bits` - Additional bits used for the subnets - The final subnet mask is the vpc_cidr mask + the value provided here, defaults to 8 which makes the subnet mask as 24
* `region` - (Optional) AWS region where Service VPC (and Multicloud-Defense Gateways) are deployed. Required when running as root module

## Outputs
* `vpc` - VPC Id
* `datapath_subnet` - A map for each zone, with subnet names and ids
    ```
    datapath_subnet = {
      "us-east-1a" = {
        "route_table_id" = "rtb-111111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1a_datapath"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1a_datapath"
      }
      "us-east-1b" = {
        "route_table_id" = "rtb-1111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1b_datapath"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1b_datapath"
      }
    }
    ```
* `mgmt_subnet` - A map for each zone, with subnet names and ids
    ```
    mgmt_subnet = {
      "us-east-1a" = {
        "route_table_id" = "rtb-111111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1a_mgmt"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1a_mgmt"
      }
      "us-east-1b" = {
        "route_table_id" = "rtb-1111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1b_mgmt"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1b_mgmt"
      }
    }
    ```
* `tgw_attachment_subnet` - A map for each zone, with subnet names and ids
    ```
    {
      "us-east-1a" = {
        "route_table_id" = "rtb-111111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1a_tgw_attachment"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1a_tgw_attachment"
      }
      "us-east-1b" = {
        "route_table_id" = "rtb-1111"
        "route_table_name" = "Multicloud-Defense_svpc_us-east-1b_tgw_attachment"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "Multicloud-Defense_svpc_us-east-1b_tgw_attachment"
      }
    }
    ```
* `mgmt_security_group` - A map of id and name
    ```
    {
      "id" = "sg-1111"
      "name" = "Multicloud-Defense_svpc_mgmt
    }
    ```
* `datapath_security_group` - A map of id and name
    ```
    {
      "id" = "sg-1111"
      "name" = "Multicloud-Defense_svpc_datapath
    }
    ```
* `Multicloud-Defense_gw_instance_details` - A structure suitable to be used as-is in the Multicloud-Defense_gateway terraform resource
    ```
    "us-east-1a" = {
      "availability_zone" = "us-east-1a"
      "mgmt_subnet" = "subnet-11111"
      "datapath_subnet" = "subnet-11112"
    }
    "us-east-1b" = {
      "availability_zone" = "us-east-1b"
      "mgmt_subnet" = "subnet-21111"
      "datapath_subnet" = "subnet-21112"
    }
    ```

## Run as root module

```
git clone https://github.com/CiscoDevNet/Multicloud-Defense.git
cd AWS/terraform-aws-service-vpc
cp provider provider.tf
cp values-sample values
```

Edit `values` with appropriate values

```
terraform init
terraform apply -var-file values
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

module "service_vpc" {
  source          = "github.com/Multicloud-Defense-security/terraform-aws-service-vpc"
  region          = "us-east-1"
  zones           = ["us-east-1a", "us-east-1b"]
  prefix          = "Multicloud-Defense_svpc"
  vpc_cidr        = "172.16.0.0/16"
  vpc_subnet_bits = 8
}
```

You can use variables instead of hard coded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
