resource "hcloud_ssh_key" "default" {
  name       = "Terraform Key"
  public_key = file("${path.module}/../ssh_key.pub")
}
