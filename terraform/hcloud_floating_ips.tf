resource "hcloud_floating_ip" "ns1" {
  type          = "ipv4"
  name          = "ns1"
  home_location = "hel1"
}

resource "hcloud_floating_ip" "ns2" {
  type          = "ipv4"
  name          = "ns2"
  home_location = "hel1"
}

resource "hcloud_floating_ip" "heh" {
  type          = "ipv4"
  name          = "heh"
  home_location = "hel1"
}
