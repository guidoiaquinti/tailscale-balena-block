#!/usr/bin/env bash
#
# This init file was inspired by https://github.com/kazazes/balena-tailscale/blob/master/init
# and https://github.com/klutchell/balena-wireguard/blob/152b37e3a080102925c61ec8863851fe24f54c9f/insmod.sh
#
set -me

if [ -z "${TAILSCALE_KEY}" ]; then
    echo "Missing TAILSCALE_KEY env variable."
    exit 1
fi

if [ ! -z "${TAILSCALE_EXIT_NODE}" ]; then
    TAILSCALE_EXIT_NODE_FLAG="--advertise-exit-node"
fi

# Wait 5s for the daemon to start and then run tailscale up to configure
tailscaled --tun=userspace-networking -state=/tailscale/tailscaled.state &
sleep 5
tailscale up \
    --authkey "${TAILSCALE_KEY}" \
    ${TAILSCALE_EXIT_NODE_FLAG} \
    $@
fg