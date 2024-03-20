# terraform-gcp-setup
Create Service Accounts, enable API Services and prepare your GCP account to enable Multicloud-Defense Controller access your account and deploy Multicloud-Defense Security Gateways. The repo provides a full working example. You can clone this and use this as a module from your other terraform scripts.

# Requirements
1. Enable terraform to access your GCP account. Check here for the options https://registry.terraform.io/providers/hashicorp/google/latest/docs (Quick Summary: `gcloud auth application-default login` or if you intend to use a Service Account to run terraform, then create a key for the service account and provide the downloaded file as the value of the `gcp_credentials_file` )
1. Permissions/Roles required for the user that runs this terraform:
    * Logging Admin - roles/loggingg.admin
    * Pub/Sub Admin - roles/pubsub.admin
    * Security Admin - roles/iam.securityAdmin
    * Service Account Admin - roles/iam.serviceAccountAdmin
    * Service Account Key Admin - roles/iam.serviceAccountKeyAdmin
    * Service Usage Admin - roles/serviceusage.serviceUsageAdmin
    * Storage Admin - roles/storage.admin
    * Compute Admin - roles/compute.admin
    * DNS Administrator - roles/dns.admin

## Variables

* `prefix` - (Required) Prefix added to the service accounts (and any other resources) created
* `project_id` - (Required) GCP Project Id where the Service Accounts (and eventually Multicloud-Defense Gateways) are created
* `gcp_credentials_file` - (Optional) GCP Credentials file (Defaults to $HOME/.config/gcloud/application_default_credentials.json)
* `bucket_location` - (Optional) Create a storage bucket in the given location. This can be used later on for enabling VPC and DNS Flow logs. Default empty (no storage bucket is created)
* `Multicloud-Defense_webhook` - (Optional) Multicloud-Defense webhook - Used to get real time inventory updates. This creates a pubsub topic, pubsub subscription, logsink. Default empty (does not create these integrations)

## Outputs

* `client_email` - Service Account used by the Multicloud-Defense Controller to manage your GCP Account
* `controller_account` - Same value as `client_email`
* `gateway_account` - Service Account used by the Multicloud-Defense Gateways
* `project_id` - Project Id that was provided in the variables
* `private_key_file_content` - This is the private key for the controller_account (or client_email). This is required during onboarding of the GCP account to the Multicloud-Defense Controller. The content is sensitive and can be displayed using `terraform output -json | jq -r .private_key_file_content.value`. If you are using the Multicloud-Defense Dashboard, then copy/paste the contents of private_key. If you are using terraform to onboard this account from another module, then save the value into a file and use this file as the argument for `gcp_credentials_file` in the `Multicloud-Defense_cloud_account` resource. If you are running this from a module, then you can use the output directly
* `storage_bucket` - If bucket location is provided, create a storage bucket and show the name

## Running as root module
```
git clone https://github.com/Multicloud-Defense-security/terraform-gcp-setup.git
cd terraform-gcp-setup
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

module "gcp_setup" {
  source                    = "github.com/Multicloud-Defense-security/terraform-gcp-setup"
  prefix                    = "someprefix"
  project_id                = "project-id-12345"
}
```

You can use variables instead of hardcoded values

In the directory where you created the above file, run the following commands

```
terraform init
terraform apply
```
