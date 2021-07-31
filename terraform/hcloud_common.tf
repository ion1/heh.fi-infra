resource "hcloud_placement_group" "heh" {
  name = "heh"
  type = "spread"
}

resource "hcloud_network" "heh" {
  name     = "heh"
  ip_range = var.net
}

resource "hcloud_network_subnet" "heh" {
  network_id   = hcloud_network.heh.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = local.subnet
}
