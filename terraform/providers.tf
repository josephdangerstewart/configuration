terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    local = {
      source = "hashicorp/local"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.78.0"
    }
  }
}

provider "digitalocean" {
  token = var.digital_ocean_token
}

provider "local" {}

provider "google" {
  project = var.google_cloud_project
  region  = "us-west2-a"
}
