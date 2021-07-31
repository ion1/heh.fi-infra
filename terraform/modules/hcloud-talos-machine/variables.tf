variable "talosctl_path" {
  type = string
}

variable "talosconfig_path" {
  type = string
}

variable "machine_config_path" {
  type = string
}

variable "name" {
  type = string
}

variable "server_type" {
  type = string
}

variable "location" {
  type = string
}

variable "placement_group_id" {
  type = string
}

variable "firewall_ids" {
  type    = list(string)
  default = []
}

variable "image" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "ssh_keys" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "private_ip_address" {
  type = string
}
