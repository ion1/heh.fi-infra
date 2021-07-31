exec 3>&1 1>&2
set -eux

"$TALOSCTL_PATH" reset \
  --graceful \
  --system-labels-to-wipe STATE,EPHEMERAL \
  --talosconfig "$TALOSCONFIG_PATH" \
  --endpoints "$PUBLIC_ADDRESS" \
  --nodes "$PUBLIC_ADDRESS"
