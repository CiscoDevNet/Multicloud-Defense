resource "google_service_account" "gateway_account" {
  depends_on = [
    google_project_service.api
  ]
  account_id   = "${var.prefix}-gateway"
  display_name = "${var.prefix}-gateway"
}

resource "google_project_iam_member" "gw_role" {
  for_each = toset([
    "roles/secretmanager.secretAccessor",
    "roles/logging.logWriter"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gateway_account.email}"
}
