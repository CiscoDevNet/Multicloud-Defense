# terraform-azure-Multicloud-Defense-iam
Create Azure AD App that is used by the Multicloud-Defense Controller to manage your Azure Subscription(s). You can clone and use this as a module from your other terraform scripts.

# Requirements
1. Enable terraform to access your Azure account. Check here for the options https://registry.terraform.io/providers/hashicorp/azuread/latest/docs and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
1. Set the default subscription to work on
1. Login to the Multicloud-Defense Dashboard and generate an API Key using the instructions provided here: https://registry.terraform.io/providers/Multicloud-Defense-security/Multicloud-Defense/latest/docs

## Argument Reference

* `prefix` - (Required) App, Custom role are created with this prefix
* `subscription_guids_list` - (Optional) List of subscriptions (Ids) to which IAM role is assigned and prepared to be onboarded onto the Multicloud-Defense Controller. Default is to use the current active subscription on the current login

## Outputs

* `tenant_id` - Azure AD Directory/Tenant Id
* `app_id` - AD App Registration Id
* `app_name` - AD App Registration Name
* `secret_key` - Secret key for the above app (Sensitive, use `terraform output -json | jq -r .secret_key.value` to see this value)
* `subscription_ids` - List of Azure Subscription Ids
* `iam_role` - Custom IAM Role name assigned to the application created

## Running as root module
```
git clone https://github.com/Multicloud-Defense-security/terraform-azure-setup.git
cd terraform-azure-setup
mv provider provider.tf
cp values.sample values
```

Edit `values` file with the appropriate values for the variables

```
terraform init
terraform apply -var-file values
```

## Using as a module (non-root module)
*To onboard the subscription onto the Multicloud-Defense Controller, uncomment the Multicloud-Defense sections in the following example and change the other values appropriately*

Create a tf file with the following content

```hcl
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.6.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    # Multicloud-Defense = {
    #   source = "Multicloud-Defense-security/Multicloud-Defense"
    # }
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}

module "csp_setup" {
  source                  = "github.com/Multicloud-Defense-security/terraform-azure-setup"
  prefix                  = "Multicloud-Defense"
  subscription_guids_list = []
}

# provider "Multicloud-Defense" {
#   api_key_file = file("~/Multicloud-Defense-controller-api-key.json")
# }

# resource "Multicloud-Defense_cloud_account" "azure" {
#   count                 = length(module.csp_setup.subscription_ids)
#   name                  = "azure-${module.csp_setup.subscription_ids[count.index]}"
#   csp_type              = "AZURE"
#   azure_directory_id    = module.csp_setup.tenant_id
#   azure_subscription_id = module.csp_setup.subscription_ids[count.index]
#   azure_application_id  = module.csp_setup.app_id
#   azure_client_secret   = module.csp_setup.secret_key
#   inventory_monitoring {
#     regions = ["us-east1", "us-west1"]
#   }
# }

```