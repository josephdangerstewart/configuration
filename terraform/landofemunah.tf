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

resource "aws_s3_bucket" "loe_public_bucket" {
  bucket = "loe-public"
}

resource "aws_s3_bucket_ownership_controls" "loe_public_bucket" {
  bucket = aws_s3_bucket.loe_public_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "loe_public_bucket" {
  bucket                  = aws_s3_bucket.loe_public_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "loe_public_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.loe_public_bucket]
  bucket     = aws_s3_bucket.loe_public_bucket.id
  acl        = "public-read"
}

resource "aws_s3_bucket" "loe_submissions_bucket" {
  bucket = "loe-submissions-bucket"
}

resource "aws_s3_bucket_ownership_controls" "loe_submissions_bucket" {
  bucket = aws_s3_bucket.loe_submissions_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "loe_submissions_bucket" {
  bucket                  = aws_s3_bucket.loe_submissions_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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
    actions   = ["s3:PutObject", "s3:PutObjectAcl"]
    resources = ["*"]
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
