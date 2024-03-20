# GCP Multicloud-Defense Service VPC using GCP Terraform Provider

Create a Multicloud-Defense Service VPC using the GCP Terraform Provider. This module creates

* datapath vpc
* mgmt vpc
* a subnet in each of the above VPCs
* firewall rules
    * datapath-ingress for the instances tagged as datapath
    * datapath-egress for the instances tagged as datapath
    * mgmt-ingress for the instances tagged as mgmt
    * mgmt-egress for the instances tagged as mgmt

## Variables

* `prefix` - (Required) Prefix used for all the resources created
* `project_id` - (Required - for root module) Project where the resources are created. Provide this value when it is run as root module. If this is run as part of another module, then the caller is assumed to configure the google provider with the correct project_id
* `region` - (Required) - Region where the resources are created, defaults to `us-east1`
* `mgmt_cidr` - (Required) - CIDR for the mgmt (management) subnet, defaults to 172.16.0.0/24
* `datapath_cidr` - (Required) - CIDR for the datapath subnet, defaults to 172.16.1.0/24

## Outputs
* `mgmt_vpc_id` - Mgmt VPC Id (self_link)
* `datapath_vpc_id` - Datapath VPC Id (self_link)
* `vpc_id` - Same as Datapath VPC Id
* `mgmt_security_group` - Network Tag that is used by the instances that wish to use the mgmt_ingress and mgmt_egress firewall rules
* `datapath_security_group` - Network Tag that is used by the instances that wish to use the datapath_ingress and datapath_egress firewall rules
* `mgmt_subnet_id` - Mgmt Subnet Id (self_link)
* `datapath_subnet_id` - Datapath Subnet Id (self_link)

## Run as root module

```
git clone https://github.com/Multicloud-Defense-security/terraform-gcp-service-vpc.git
cd terraform-gcp-service-vpc
mv provider provider.tf
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
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "project-id-12345"
  # setup your optional gcp credentials here
  # credentials = "creds-filename.json"
}

module "service_vpc" {
  source        = "github.com/Multicloud-Defense-security/terraform-gcp-service-vpc"
  prefix        = "someprefix"
  project_id    = "project-id-12345"
  mgmt_cidr     = "172.16.0.0/24"
  datapath_cidr = "172.16.1.0/24"
}
```

You can use variables instead of hard coded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
