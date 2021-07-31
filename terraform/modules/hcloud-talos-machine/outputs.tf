output "id" {
  value = hcloud_server.talos_machine.id
}

output "name" {
  value = hcloud_server.talos_machine.name
}

output "server_type" {
  value = hcloud_server.talos_machine.server_type
}

output "image" {
  value = hcloud_server.talos_machine.image
}

output "location" {
  value = hcloud_server.talos_machine.location
}

output "datacenter" {
  value = hcloud_server.talos_machine.datacenter
}

output "backup_window" {
  value = hcloud_server.talos_machine.backup_window
}

output "backups" {
  value = hcloud_server.talos_machine.backups
}

output "iso" {
  value = hcloud_server.talos_machine.iso
}

output "ipv4_address" {
  value = hcloud_server.talos_machine.ipv4_address
}

output "ipv6_address" {
  value = hcloud_server.talos_machine.ipv6_address
}

output "ipv6_network" {
  value = hcloud_server.talos_machine.ipv6_network
}

output "status" {
  value = hcloud_server.talos_machine.status
}

output "labels" {
  value = hcloud_server.talos_machine.labels
}

output "firewall_ids" {
  value = hcloud_server.talos_machine.firewall_ids
}

output "placement_group_id" {
  value = hcloud_server.talos_machine.placement_group_id
}

output "server_network_id" {
  value = hcloud_server_network.talos_machine.id
}

output "network_id" {
  value = hcloud_server_network.talos_machine.network_id
}

output "private_ip_address" {
  value = hcloud_server_network.talos_machine.ip
}

output "private_alias_ip_addresses" {
  value = hcloud_server_network.talos_machine.alias_ips
}

output "talos_public_address" {
  value = shell_script.talos_machine.output["public_address"]
}

output "talos_private_address" {
  value = shell_script.talos_machine.output["private_address"]
}
