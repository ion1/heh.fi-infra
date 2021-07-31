terraform {
  backend "remote" {
    organization = "heh-fi"

    workspaces {
      name = "infra"
    }
  }
}
