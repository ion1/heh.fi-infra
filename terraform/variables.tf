variable "hcloud_talos_image" {
  type = string
}

variable "admin_cidrs" {
  type    = list(string)
  default = []
  validation {
    condition     = alltrue([for cidr in var.admin_cidrs : length(cidrhost(cidr, 0)) > 0])
    error_message = "Expected a list of valid CIDR addresses."
  }
}

variable "master_nodes" {
  type    = number
  default = 3
}

variable "worker_nodes" {
  type    = number
  default = 3
}

variable "net" {
  type    = string
  default = "10.0.0.0/8"
}

locals {
  subnet            = cidrsubnet(var.net, 8, 0)
  master_ip_range   = cidrsubnet(local.subnet, 8, 1)
  worker_ip_range   = cidrsubnet(local.subnet, 8, 2)
  control_plane_vip = cidrhost(local.master_ip_range, 100)
}
