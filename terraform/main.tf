resource "hcloud_firewall" "control_plane" {
  name = "Control Plane"

  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "Admin, Kubernetes"
    direction   = "in"
    protocol    = "tcp"
    port        = 6443
    source_ips  = var.admin_cidrs
  }
  rule {
    description = "Admin, Talos"
    direction   = "in"
    protocol    = "tcp"
    port        = 50000
    source_ips  = var.admin_cidrs
  }
}

resource "hcloud_firewall" "worker" {
  name = "Worker"

  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "Admin, Talos"
    direction   = "in"
    protocol    = "tcp"
    port        = 50000
    source_ips  = var.admin_cidrs
  }
}

module "talos_master" {
  source = "./modules/hcloud-talos-machine"

  count = var.master_nodes

  talosctl_path       = "../bin/talosctl"
  talosconfig_path    = "../talos/talosconfig"
  machine_config_path = "../talos/controlplane.yaml"

  name               = "master-${count.index + 1}"
  server_type        = "cpx11"
  location           = "hel1"
  placement_group_id = hcloud_placement_group.heh.id
  firewall_ids       = [hcloud_firewall.control_plane.id]
  image              = var.hcloud_talos_image
  labels             = { role = "control-plane" }
  ssh_keys           = [hcloud_ssh_key.default.id]

  subnet_id          = hcloud_network_subnet.heh.id
  private_ip_address = cidrhost(local.master_ip_range, 2 + count.index)
}

module "talos_worker" {
  source = "./modules/hcloud-talos-machine"

  count = var.worker_nodes

  talosctl_path       = "../bin/talosctl"
  talosconfig_path    = "../talos/talosconfig"
  machine_config_path = "../talos/worker.yaml"

  name               = "worker-${count.index + 1}"
  server_type        = "cpx11"
  location           = "hel1"
  placement_group_id = hcloud_placement_group.heh.id
  firewall_ids       = [hcloud_firewall.worker.id]
  image              = var.hcloud_talos_image
  labels             = { role = "worker" }
  ssh_keys           = [hcloud_ssh_key.default.id]

  subnet_id          = hcloud_network_subnet.heh.id
  private_ip_address = cidrhost(local.worker_ip_range, 2 + count.index)
}

module "talos_cluster" {
  source = "./modules/talos-cluster"

  talosctl_path    = "../bin/talosctl"
  talosconfig_path = "../talos/talosconfig"

  control_plane_public_addresses  = module.talos_master.*.talos_public_address
  control_plane_private_addresses = module.talos_master.*.talos_private_address
  worker_public_addresses         = module.talos_worker.*.talos_public_address
  worker_private_addresses        = module.talos_worker.*.talos_private_address
}
