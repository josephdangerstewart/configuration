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

resource "aws_s3_bucket" "loe_submissions_bucket" {
  bucket = "loe-submissions-bucket"
}

resource "aws_iam_user" "loe_aws_user" {
  name = "loe-aws-user"
}

resource "aws_iam_access_key" "loe_aws_user" {
  user = aws_iam_user.loe_aws_user.name
}

resource "local_file" "loe_aws_user_key_json" {
  content = jsonencode({
    "accessKeyId"     = aws_iam_access_key.loe_aws_user.id
    "secretAccessKey" = aws_iam_access_key.loe_aws_user.secret
  })
  filename = "secrets/loe_aws_user_key.json"
}

data "aws_iam_policy_document" "loe_s3_policy" {
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.loe_submissions_bucket.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_user_policy" "loe_aws_user" {
  name   = "loe-aws-user-policy"
  user   = aws_iam_user.loe_aws_user.name
  policy = data.aws_iam_policy_document.loe_s3_policy.json
}

resource "google_recaptcha_enterprise_key" "loe_recaptcha" {
  display_name = "loe_recaptcha"
  labels       = {}

  web_settings {
    integration_type  = "SCORE"
    allow_all_domains = true
  }
}
