variable "digital_ocean_token" {
  type      = string
  sensitive = true
}

variable "google_cloud_project" {
  type    = string
  default = "personal-projects-396500"
}
