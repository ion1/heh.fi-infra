terraform {
  required_version = "~> 1.0"
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.30"
    }
  }
}

provider "hcloud" {
}
