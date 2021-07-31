variable "talosctl_path" {
  type = string
}

variable "talosconfig_path" {
  type = string
}

variable "control_plane_public_addresses" {
  type = list(string)
}

variable "control_plane_private_addresses" {
  type = list(string)
}

variable "worker_public_addresses" {
  type = list(string)
}

variable "worker_private_addresses" {
  type = list(string)
}
