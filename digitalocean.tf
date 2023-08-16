resource "digitalocean_droplet" "do_hannah_web01" {
  backups    = false
  name       = "do-hannah-web01"
  size       = "s-1vcpu-1gb"
  image      = "nodejs-20-04"
  region     = "SFO2"
  monitoring = true
}

resource "digitalocean_droplet" "do_hannah_web02" {
  backups    = false
  name       = "do-hannah-web02"
  size       = "s-1vcpu-1gb"

  # Imported resource, that's why this image is a funky number
  image      = 48826207
  region     = "SFO2"
  monitoring = true
}
