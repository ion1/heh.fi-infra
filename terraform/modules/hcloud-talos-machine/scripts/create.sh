exec 3>&1 1>&2
set -eux

# Verify the presence of jq (required by read.sh)
which jq >/dev/null

until "$TALOSCTL_PATH" apply-config --insecure --nodes "$PUBLIC_ADDRESS" --file "$MACHINE_CONFIG_PATH"; do
  sleep 1
done
