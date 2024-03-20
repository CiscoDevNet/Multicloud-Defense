output "project_id" {
  value = var.project_id
}

output "client_email" {
  value = google_service_account.controller_account.email
}

output "controller_account" {
  value = google_service_account.controller_account.email
}

output "gateway_account" {
  value = google_service_account.gateway_account.email
}

output "private_key_file_content" {
  description = "Content of the private key file of the Controller Service Account"
  value       = base64decode(google_service_account_key.controller_account_key.private_key)
  sensitive   = true
}

output "storage_bucket" {
  value = var.bucket_location == "" ? "" : google_storage_bucket.discovery[0].name
}
