# Terraform for Peering Spoke VPC with Multicloud-Defense Service VPC
Setup VPC peering between Multicloud-Defense Service VPC (Datapatah VPC) and the Spoke VPC. Add a default route in the Spoke VPC with next hop set to the Multicloud-Defense Egress Gateway Endpoint

## Variables

* `project_id` - (Required) GCP Project Id where the peerings and routes are created
* `Multicloud-Defense_egress_gw_endpoint` - (Required) IP Address of the Multicloud-Defense Egress Gateway Endpoint
* `Multicloud-Defense_service_vpc_id` - (Required) Multicloud-Defense Service VPC Id (Datapath VPC) (self_link)
* `spoke_vpc_id` - (Required) Spoke VPC Id (self_link) that needs to be peered with the Multicloud-Defense Service VPC

## Running as root module
```
git clone https://github.com/Multicloud-Defense-security/terraform-gcp-spoke-vpc.git
cd terraform-gcp-spoke-vpc
mv provider provider.tf
cp values.sample values
```

Edit `values` file with the appropriate values for the variables

```
terraform init
terraform apply -var-file values
```

## Using as a module (non-root module)

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

module "spoke_peering" {
  source                    = "github.com/Multicloud-Defense-security/terraform-gcp-spoke-vpc"
  Multicloud-Defense_egress_gw_endpoint = "172.16.1.2"
  Multicloud-Defense_service_vpc_id     = "Multicloud-Defense service vpc self_link"
  spoke_vpc_id              = "spoke vpc self_link"
}
```

You can use variables instead of hardcoded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
