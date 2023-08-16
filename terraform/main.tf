# Digital ocean resources
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

resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/ansible_inventory.tftpl", {
    digital_ocean_ips = [
      digitalocean_droplet.do_hannah_web01.ipv4_address,
      digitalocean_droplet.do_hannah_web02.ipv4_address
    ]
  })
  filename = "../ansible/terraform_output/hosts.cfg"
}
