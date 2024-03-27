variable "prefix" {
  description = "Prefix used for the service accounts"
  default     = "ciscomcd"
}

variable "project_id" {
  description = "Project Id"
}

variable "gcp_credentials_file" {
  description = "GCP Credentials file, either downloaded as key of a Service Account or using gcloud auth application-default login"
  default     = "~/.config/gcloud/application_default_credentials.json"
}

variable "disable_api_services_on_destroy" {
  description = "Disable gcloud apiservices on terraform destroy"
  default     = false
}

variable "bucket_location" {
  description = "Storage bucket location, this is used (later on) to enable VPC and DNS flow logs. If the value is empty, the bucket will not be created"
  default     = ""
}

variable "ciscomcd_webhook" {
  description = "ciscomcd webhook for real time inventory updates"
  default     = ""
}
