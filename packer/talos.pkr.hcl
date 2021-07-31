variable "talos_version" {
  type = string
}

variable "image_directory" {
  type    = string
  default = "../images"
}

variable "hcloud_token" {
  type      = string
  sensitive = true
  default   = env("HCLOUD_TOKEN")
}

source "hcloud" "rescue" {
  # The image is irrelevant, the OS will be overwritten with Talos.
  image       = "ubuntu-20.04"
  server_type = "cx11"
  location    = "hel1"
  rescue      = "linux64"
  snapshot_labels = {
    name    = "talos"
    version = var.talos_version
    date    = formatdate("YYYYMMDD", timestamp())
  }
  snapshot_name = "talos-${var.talos_version} ${formatdate("YYYYMMDD", timestamp())}"
  ssh_username  = "root"
  token         = var.hcloud_token
}

build {
  sources = ["source.hcloud.rescue"]

  provisioner "file" {
    source      = "${var.image_directory}/talos-${var.talos_version}.raw.xz"
    destination = "/talos.raw.xz"
  }

  provisioner "shell" {
    inline = [
      "set -eux",
      "gdisk -l /dev/sda",

      "blkdiscard /dev/sda",
      "xzcat /talos.raw.xz | dd conv=sparse of=/dev/sda bs=512",
      "partprobe /dev/sda",
      "gdisk -l /dev/sda",
    ]
  }
}
