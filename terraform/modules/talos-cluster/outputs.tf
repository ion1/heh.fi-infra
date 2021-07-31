output "control_plane_public_addresses" {
  value = shell_script.talos_cluster.output["control_plane_public_addresses"]
}

output "control_plane_private_addresses" {
  value = shell_script.talos_cluster.output["control_plane_private_addresses"]
}

output "worker_public_addresses" {
  value = shell_script.talos_cluster.output["worker_public_addresses"]
}

output "worker_private_addresses" {
  value = shell_script.talos_cluster.output["worker_private_addresses"]
}
