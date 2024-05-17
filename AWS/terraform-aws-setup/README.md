# Setup AWS Account IAM Roles, Add Account to the Multicloud-Defense Contoller
Create IAM roles and prepare your AWS account to enable Multicloud Defense Controller access your account and deploy Multicloud Defense Security Gateways.

# Requirements
1. Enable terraform to access your aws account. Check here for the options https://registry.terraform.io/providers/hashicorp/aws/latest/docs.
1. Login to the Multicloud Defense Dashboard and generate an API Key using the instructions provided here: https://registry.terraform.io/providers/Multicloud-Defense-security/Multicloud-Defense/latest/docs

## Argument Reference

* `prefix` - (Required) Prefix added to all the resources created on the AWS account
* `controller_aws_account_number` - (Required) AWS controller account number provided by Multicloud-Defense
* `Multicloud-Defense_api_key_file` - (Required) Multicloud-Defense API Key JSON file downloaded from the Multicloud-Defense Controller. This is used to get the external id from the Multicloud-Defense Controller that is used in the trust relationship for cross account iam role
* `deployment_name` - (Optional) Multicloud-Defense Deployment Name. Ask Multicloud-Defense for this information. Default value is `prod1` unless you work with Multicloud-Defense for a custom deployment
* `s3_bucket` - (Optional) S3 bucket name to store VPC Flow Logs, DNS Query Logs and optionally CloudTrail events. Set this to empty string if Discovery features are not required, default is empty (S3 bucket is NOT created) 
* `object_duration` - (Optional) Number of days after which the objects in the above S3 bucket are deleted (Default 1 day)
* `create_cloud_trail` - (Optional) true/false. Create a new multi-region CloudTrail and log the events to the provided S3 Bucket. S3 Bucket must be provided for this variable to take effect. If you already have a multi-region CloudTrail in your account, set this value to false to not create another CloudTrail. (Default true and is applicable only if `s3_bucket` is defined)
* `Multicloud-Defense_aws_cloud_account_name` - (Optional) Name used to represent this AWS Account on the Multicloud-Defense Controller. If the value is empty, the account is not added. Default is empty
* `inventory_regions` - (Optional) List of AWS regions that Multicloud-Defense Controller can monitor and update the inventory for dynamic security policies, this is used only when `Multicloud-Defense_aws_cloud_account_name` is not empty

### These parameters are required when run as root module (by cloning this code and run), otherwise the parent module would have to set the credentials and region
* `aws_credentials_profile` - (Optional) Required when run as root module. The profile name to use to login to the AWS account to add the IAM roles as described in this document.
* `region` - (Optional) Required when run as root module. AWS Region (Home region for CloudTrail, S3 Bucket)

## Outputs

* `cloud_account_name` - Multicloud-Defense Cloud Account Name (same as input variable `Multicloud-Defense_aws_cloud_account_name`)
* `cloud_trail` - Map of CloudTrail name and arn
    ```
    {
      "arn" = "cloud_trail-arn"
      "name" = "cloud_trail-name"
    }
    ```
* `external_id` - Controller IAM Role external id, this is sensitive. Use `terraform output -json` to get the value. If the cloud account is onboarded in this module, then you don't need this value
* `s3_bucket` - Map of S3 Bucket name and arn
    ```
    {
      "arn" = "s3_bucket-arn"
      "name" = "s3_bucket-name"
    }
    ```
* `Multicloud-Defense_controller_role` - Map of Multicloud-Defense Controller IAM Role's name and arn
    ```
    {
      "arn" = "Multicloud-Defense_controller_role-arn"
      "name" = "Multicloud-Defense_controller_role-name"
    }
    ```
* `Multicloud-Defense_controller_role_arn` - IAM Role used by the Multicloud-Defense Controller to manage the AWS account (Backward Compatibility, use the map above for new deployments)
* `Multicloud-Defense_firewall_role` - Map of Multicloud-Defense Gateway/Firewall IAM Role's name and arn
    ```
    {
      "arn" = "Multicloud-Defense_firewall_role-arn"
      "name" = "Multicloud-Defense_firewall_role-name"
    }
    ```
* `Multicloud-Defense_inventory_role` - Map of Multicloud-Defense Inventory IAM Role's name and arn
    ```
    {
      "arn" = "Multicloud-Defense_inventory_role-arn"
      "name" = "Multicloud-Defense_inventory_role-name"
    }
    ```
* `z_console_urls` - Friendly AWS Console URLs for the IAM roles 

## Running as root module
```
git clone https://github.com/Multicloud-Defense-security/terraform-aws-setup.git
cd terraform-aws-setup
mv provider provider.tf
cp values-sample values
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
    Multicloud-Defense = {
      source = "Multicloud-Defense-security/Multicloud-Defense"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "profilename"
  region  = "us-east-1"
}

provider "Multicloud-Defense" {
  api_key_file = file("Multicloud-Defense_api.json")
}

module "csp_setup" {
  source                        = "github.com/Multicloud-Defense-security/terraform-aws-setup"
  # define the values for all the variables (use values-sample as a reference)
  deployment_name               = "prod1"
  prefix                        = "Multicloud-Defense"
  controller_aws_account_number = "Multicloud-Defense-aws-account-number"
  s3_bucket                     = "Multicloud-Defense-12345"
  object_duration               = 1
  create_cloud_trail            = true
  # required only if you intend to onboard the account to the Multicloud-Defense Controller
  Multicloud-Defense_aws_cloud_account_name = "aws-account-name-on-Multicloud-Defense"
  inventory_regions             = ["us-east-1", "us-east-2"]
}
```
