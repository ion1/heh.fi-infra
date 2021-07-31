resource "shell_script" "talos_cluster" {
  lifecycle_commands {
    create = <<-E
      exec 3>&1 1>&2
      set -eux
      until "$TALOSCTL_PATH" bootstrap \
        --talosconfig "$TALOSCONFIG_PATH" \
        --endpoints "$CONTROL_PLANE_PUBLIC_ADDRESSES" \
        --nodes "$BOOTSTRAP_NODE"
      do
        sleep 1
      done
    E
    update = <<-E
      exec 3>&1 1>&2
      set -eux
    E
    delete = <<-E
      exec 3>&1 1>&2
      set -eux
      >&2 printf "ERROR: Cluster deletion not supported.\n"
      exit 1
    E
    read   = <<-E
      exec 3>&1 1>&2
      set -eux
      >&3 jq -n '{
        control_plane_public_addresses: env.CONTROL_PLANE_PUBLIC_ADDRESSES | split(","),
        control_plane_private_addresses: env.CONTROL_PLANE_PRIVATE_ADDRESSES | split(","),
        worker_public_addresses: env.WORKER_PUBLIC_ADDRESSES | split(","),
        worker_private_addresses: env.WORKER_PRIVATE_ADDRESSES | split(",")
      }'
    E
  }

  environment = {
    TALOSCTL_PATH                   = var.talosctl_path
    TALOSCONFIG_PATH                = var.talosconfig_path
    BOOTSTRAP_NODE                  = var.control_plane_private_addresses[0]
    CONTROL_PLANE_PUBLIC_ADDRESSES  = join(",", var.control_plane_public_addresses)
    CONTROL_PLANE_PRIVATE_ADDRESSES = join(",", var.control_plane_private_addresses)
    WORKER_PUBLIC_ADDRESSES         = join(",", var.worker_public_addresses)
    WORKER_PRIVATE_ADDRESSES        = join(",", var.worker_private_addresses)
  }
}
