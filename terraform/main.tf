locals {
  ssh_keys = zipmap(fileset("../ssh_keys", "*.pub"), [for fileName in fileset("../ssh_keys", "*.pub") : file("../ssh_keys/${fileName}")])
}

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
  backups = false
  name    = "do-hannah-web02"
  size    = "s-1vcpu-1gb"

  # Imported resource, that's why this image is a funky number
  image      = 48826207
  region     = "SFO2"
  monitoring = true
}

resource "digitalocean_ssh_key" "ssh_keys" {
  for_each = local.ssh_keys

  name       = each.key
  public_key = each.value
}

resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/ansible_inventory.tftpl", {
    node_servers = [
      digitalocean_droplet.do_hannah_web01,
      digitalocean_droplet.do_hannah_web02
    ]
  })
  filename = "../ansible/terraform_output/hosts.cfg"
}
