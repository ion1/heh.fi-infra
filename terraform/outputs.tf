output "heh_address" {
  value = hcloud_floating_ip.heh.ip_address
}

output "ns1_address" {
  value = hcloud_floating_ip.ns1.ip_address
}

output "ns2_address" {
  value = hcloud_floating_ip.ns2.ip_address
}

output "master_address" {
  value = [module.talos_master.*.ipv4_address]
}

output "worker_address" {
  value = [module.talos_worker.*.ipv4_address]
}

output "master_private_address" {
  value = [module.talos_master.*.private_ip_address]
}

output "worker_private_address" {
  value = [module.talos_worker.*.private_ip_address]
}

output "hcloud_network_id" {
  value = hcloud_network.heh.id
}
