terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "digitalocean" {
  token = var.digital_ocean_token
}

provider "local" {}
