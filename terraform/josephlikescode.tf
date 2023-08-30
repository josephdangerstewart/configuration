resource "google_service_account" "jlc_service_account" {
  account_id  = "land-of-emunah"
  description = "The account for managing land of emunah resources"
}

resource "google_service_account_key" "jlc_service_account_key" {
  service_account_id = google_service_account.jlc_service_account.name
}

resource "local_file" "jlc_service_account_key_json" {
  content  = base64decode(google_service_account_key.jlc_service_account_key.private_key)
  filename = "secrets/jlc_service_account_key.json"
}

resource "google_project_iam_member" "jlc_sa_recaptcha_permissions" {
  project = var.google_cloud_project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.jlc_service_account.email}"
}

resource "google_recaptcha_enterprise_key" "jcl_recaptcha" {
  display_name = "jcl_recaptcha"
  labels       = {}

  web_settings {
    integration_type  = "SCORE"
    allow_all_domains = true
  }
}
