Set the environment variables `HCLOUD_TOKEN` for Packer and
`TF_VAR_hcloud_token` for Terraform.

Download the required files and create the configs under `talos`:

```
$ make
$ bin/talosctl config merge talos/talosconfig
```

Build the image and make a note of the snapshot ID in the output.

```
$ make packer-build
```

Refer to the snapshot ID in the Terraform code and deploy the servers:

```
$ make terraform-apply
$ make terraform-output
```

Set the endpoint:

```
$ bin/talosctl config endpoint 1.2.3.4
```

Get the kubeconfig:

```
$ bin/talosctl kubeconfig -n 1.2.3.4
```
