exec 3>&1 1>&2
set -eux

>&3 jq -n '{ public_address: env.PUBLIC_ADDRESS, private_address: env.PRIVATE_ADDRESS }'
