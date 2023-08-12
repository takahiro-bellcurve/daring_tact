resource "google_storage_bucket" "functions_bucket" {
  name     = "${local.project_name}-functions"
  location = "asia-northeast1"
}

resource "google_storage_bucket_object" "functions_packages" {
  name   = "${local.project_name}/cloud-functions/slack_webhook/functions-${formatdate("YYYYMMDD-hhmm", timestamp())}.zip"
  bucket = "${google_storage_bucket.functions_bucket.name}"
  source = "./src/output/slack_webhook.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "slack_webhook"
  description = "function for slack webhook"
  runtime     = "python37"

  available_memory_mb   = 128
  source_archive_bucket = "${google_storage_bucket.functions_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.functions_packages.name}"
  timeout               = 10
  entry_point           = "handler"
  trigger_http          = true
}