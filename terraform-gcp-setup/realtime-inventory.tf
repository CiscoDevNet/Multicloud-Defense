resource "google_pubsub_topic" "invtopic" {
  count = var.ciscomcd_webhook == "" ? 0 : 1
  name  = "${var.prefix}-inventory-topic"
}

resource "google_pubsub_subscription" "invsub" {
  count = var.ciscomcd_webhook == "" ? 0 : 1
  name  = "${var.prefix}-inventory-subscription"
  topic = google_pubsub_topic.invtopic[count.index].name
  push_config {
    push_endpoint = var.ciscomcd_webhook
  }
}

resource "google_logging_project_sink" "invsink" {
  count                  = var.ciscomcd_webhook == "" ? 0 : 1
  name                   = "${var.prefix}-inventory-sink"
  destination            = "pubsub.googleapis.com/${google_pubsub_topic.invtopic[count.index].id}"
  filter                 = "resource.type=(\"gce_instance\" OR \"gce_network\" OR \"gce_subnetwork\" OR \"gce_forwarding_rule\" OR \"gce_target_pool\" OR \"gce_backend_service\" OR \"gce_target_http_proxy\" OR \"gce_target_https_proxy\") logName=\"${data.google_project.project.id}/logs/cloudaudit.googleapis.com%2Factivity\""
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_member" "member" {
  count  = var.ciscomcd_webhook == "" ? 0 : 1
  topic  = google_pubsub_topic.invtopic[count.index].name
  role   = "roles/pubsub.publisher"
  member = google_logging_project_sink.invsink[count.index].writer_identity
}

resource "google_storage_bucket" "discovery" {
  count         = var.bucket_location == "" ? 0 : 1
  name          = "${var.prefix}-log-bucket"
  force_destroy = true
  location      = var.bucket_location
}
