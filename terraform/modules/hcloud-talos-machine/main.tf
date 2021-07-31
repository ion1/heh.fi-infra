resource "hcloud_server" "talos_machine" {
  name               = var.name
  server_type        = var.server_type
  location           = var.location
  placement_group_id = var.placement_group_id
  firewall_ids       = var.firewall_ids
  image              = var.image
  labels             = var.labels
  ssh_keys           = var.ssh_keys
}

resource "hcloud_server_network" "talos_machine" {
  server_id = hcloud_server.talos_machine.id
  subnet_id = var.subnet_id
  ip        = var.private_ip_address
}

resource "shell_script" "talos_machine" {
  lifecycle_commands {
    create = file("${path.module}/scripts/create.sh")
    delete = file("${path.module}/scripts/delete.sh")
    read   = file("${path.module}/scripts/read.sh")
  }

  environment = {
    TALOSCTL_PATH       = var.talosctl_path
    TALOSCONFIG_PATH    = var.talosconfig_path
    MACHINE_CONFIG_PATH = var.machine_config_path
    PUBLIC_ADDRESS      = hcloud_server.talos_machine.ipv4_address
    PRIVATE_ADDRESS     = hcloud_server_network.talos_machine.ip
  }
}
