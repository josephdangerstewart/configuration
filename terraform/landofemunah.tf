# Resources specifically for land of emunah (DNS, captcha, etc)

resource "google_service_account" "loe_service_account" {
  account_id  = "land-of-emunah"
  description = "The account for managing land of emunah resources"
}

resource "google_service_account_key" "loe_service_account_key" {
  service_account_id = google_service_account.loe_service_account.name
}

resource "local_file" "loe_service_account_key_json" {
  content  = base64decode(google_service_account_key.loe_service_account_key.private_key)
  filename = "secrets/loe_service_account_key.json"
}

resource "google_project_iam_member" "loe_sa_recaptcha_permissions" {
  project = var.google_cloud_project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.loe_service_account.email}"
}

resource "google_recaptcha_enterprise_key" "loe_recaptcha" {
  display_name = "loe_recaptcha"
  labels       = {}

  web_settings {
    integration_type  = "SCORE"
    allow_all_domains = true
  }
}
