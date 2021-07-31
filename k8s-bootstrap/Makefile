export PATH := ../bin:$(PATH)

.PHONY: all

all:
	>cni.yaml kustomize build cni
	>external-cloud-provider.yaml kustomize build external-cloud-provider
	>extra-manifests.yaml kustomize build extra-manifests
