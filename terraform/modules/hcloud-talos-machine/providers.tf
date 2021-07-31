terraform {
  required_version = "~> 1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.30"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1.7"
    }
  }
}
