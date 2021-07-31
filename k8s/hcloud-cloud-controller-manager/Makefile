hcloud_ccm_version := 1.12.0

hcloud_ccm_url := https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/download/v$(hcloud_ccm_version)/ccm-networks.yaml

hcloud-cloud-controller-manager-$(hcloud_ccm_version).yaml:
	curl -L -o '$@' '$(hcloud_ccm_url)'
