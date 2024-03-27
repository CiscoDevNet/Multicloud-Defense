resource "google_project_service" "api" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "pubsub.googleapis.com",
    "logging.googleapis.com",
    "dns.googleapis.com",
    "secretmanager.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = var.disable_api_services_on_destroy
}
