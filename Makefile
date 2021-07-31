export PATH := bin:$(PATH)

talos_version := 0.13.0-alpha.0
yq_version := 4.12.2
kubernetes_version := 1.22.1
kustomize_version := 4.3.0
helm_version := 3.6.3
calicoctl_version := 3.20.0

# https://github.com/talos-systems/talos/releases/download/v0.12.1/sha256sum.txt
talos_url := https://github.com/talos-systems/talos/releases/download/v$(talos_version)/hcloud-amd64.raw.xz
talos_sha256sum := 33746cdc28901c2e7abfbed180c2d9f9b721d5db3d8df8940dedfb3a1802109c

talosctl_url := https://github.com/talos-systems/talos/releases/download/v$(talos_version)/talosctl-linux-amd64
talosctl_sha256sum := ed7f3be53f6aaf927b80bb9c997cbcdb1146828ec18fff3ae43d845cee696fdd

# https://github.com/mikefarah/yq/releases/download/v4.12.2/checksums
yq_url := https://github.com/mikefarah/yq/releases/download/v$(yq_version)/yq_linux_amd64
yq_sha256sum := 3800de63976a5d26e5207f37fd4ab824e0fff538eb3e2624e65542d4153dcfdf

# https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl.sha256
kubectl_url := https://dl.k8s.io/release/v$(kubernetes_version)/bin/linux/amd64/kubectl
kubectl_sha256sum := 78178a8337fc6c76780f60541fca7199f0f1a2e9c41806bded280a4a5ef665c9

# https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.3.0/checksums.txt
kustomize_url := https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv$(kustomize_version)/kustomize_v$(kustomize_version)_linux_amd64.tar.gz
kustomize_sha256sum := d34818d2b5d52c2688bce0e10f7965aea1a362611c4f1ddafd95c4d90cb63319

# https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz.sha256sum
helm_url := https://get.helm.sh/helm-v$(helm_version)-linux-amd64.tar.gz
helm_sha256sum := 07c100849925623dc1913209cd1a30f0a9b80a5b4d6ff2153c609d11b043e262

calicoctl_url := https://github.com/projectcalico/calicoctl/releases/download/v$(calicoctl_version)/calicoctl-linux-amd64
calicoctl_sha256sum := 5a1462e3d9c5bc3142b14788b5be427fae962863397a0176241afad02308f1a2

downloaded_files := \
  images/talos-$(talos_version).raw.xz \
  bin/talosctl bin/talosctl-$(talos_version) \
  bin/yq bin/yq-$(yq_version) \
  bin/kubectl bin/kubectl-$(kubernetes_version) \
  bin/kustomize bin/kustomize-$(kustomize_version) \
  bin/helm bin/helm-$(helm_version) \
  bin/calicoctl bin/calicoctl-$(calicoctl_version)

talos_source_files := talos-source/talosconfig talos-source/controlplane.yaml talos-source/worker.yaml
talos_config_files := talos/talosconfig talos/controlplane.yaml talos/worker.yaml

files := $(talos_config_files) $(downloaded_files)

.PHONY: all
all: $(files)

.PHONY: packer-build
packer-build:
	cd packer && packer build -var 'talos_version=$(talos_version)' talos.pkr.hcl

.PHONY: terraform-plan terraform-apply terraform-output
terraform-plan:
	cd terraform && terraform plan
terraform-apply:
	cd terraform && terraform apply
terraform-output:
	cd terraform && terraform output

.PHONY: clean
clean:
	$(RM) -r images bin

$(talos_source_files): | bin/talosctl
	talosctl gen config heh-hetzner-hel1 https://kube.hetzner-hel1.heh.fi:6443 \
	  -o talos-source --with-docs=false --with-examples=false

talos/talosconfig: talos-source/talosconfig
	mkdir -pv '$(dir $@)'
	cp -a '$<' '$@'

talos/%.yaml: talos-source/%.yaml talos-patch/common.yaml talos-patch/%.yaml | bin/yq
	mkdir -pv '$(dir $@)'
	>'$@' yq ea '. as $$item ireduce ({}; . * $$item)' $^
	talosctl validate -m cloud --strict -c '$@'

images/talos-$(talos_version).raw.xz:
	./download \
	  --sha256='$(talos_sha256sum)' \
	  --url='$(talos_url)' \
	  --target='$@'

bin/talosctl-$(talos_version):
	./download \
	  --sha256='$(talosctl_sha256sum)' \
	  --url='$(talosctl_url)' \
	  --mode=0755 \
	  --target='$@'

bin/talosctl: bin/talosctl-$(talos_version)
	ln -fs '$(notdir $<)' '$@'

bin/yq-$(yq_version):
	./download \
	  --sha256='$(yq_sha256sum)' \
	  --url='$(yq_url)' \
	  --mode=0755 \
	  --target='$@'

bin/yq: bin/yq-$(yq_version)
	ln -fs '$(notdir $<)' '$@'

bin/kubectl-$(kubernetes_version):
	./download \
	  --sha256='$(kubectl_sha256sum)' \
	  --url='$(kubectl_url)' \
	  --mode=0755 \
	  --target='$@'

bin/kubectl: bin/kubectl-$(kubernetes_version)
	ln -fs '$(notdir $<)' '$@'

bin/kustomize-$(kustomize_version):
	./download \
	  --sha256='$(kustomize_sha256sum)' \
	  --url='$(kustomize_url)' \
	  --extract=kustomize \
	  --target='$@'

bin/kustomize: bin/kustomize-$(kustomize_version)
	ln -fs '$(notdir $<)' '$@'

bin/helm-$(helm_version):
	./download \
	  --sha256='$(helm_sha256sum)' \
	  --url='$(helm_url)' \
	  --extract=linux-amd64/helm \
	  --target='$@'

bin/helm: bin/helm-$(helm_version)
	ln -fs '$(notdir $<)' '$@'

bin/calicoctl-$(calicoctl_version):
	./download \
	  --sha256='$(calicoctl_sha256sum)' \
	  --url='$(calicoctl_url)' \
	  --mode=0755 \
	  --target='$@'

bin/calicoctl: bin/calicoctl-$(calicoctl_version)
	ln -fs '$(notdir $<)' '$@'
