resource "google_service_account" "controller_account" {
  depends_on = [
    google_project_service.api
  ]
  account_id   = "${var.prefix}-controller"
  display_name = "${var.prefix}-controller"
  description  = "Service account used by the ciscomcd Controller to manage GCP project"
}

resource "google_project_iam_member" "controller_role" {
  for_each = toset([
    "roles/compute.admin",
    "roles/iam.serviceAccountUser",
    "roles/pubsub.admin",
    "roles/logging.admin",
    "roles/storage.admin"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.controller_account.email}"
}

resource "google_service_account_key" "controller_account_key" {
  service_account_id = google_service_account.controller_account.id
  public_key_type    = "TYPE_X509_PEM_FILE"
}
