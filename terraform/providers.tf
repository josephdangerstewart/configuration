terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.29.0, < 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0, < 3.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.78.0, < 5.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.13.1, < 6.0.0"
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

provider "aws" {}
