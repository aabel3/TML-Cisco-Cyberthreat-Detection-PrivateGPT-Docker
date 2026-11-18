#!/bin/bash
#
# run-tml-cisco.bash
# TML-Cisco cyberthreat detection lab
#
# Starts the TML-Cisco container with its settings read from an env file, and
# prints the dashboard URL. The Confluent Cloud secret is passed to Docker by
# name, so it does not appear in the process list or in your shell history.
#
# Usage:  ./run-tml-cisco.bash [env_file]
# Example: ./run-tml-cisco.bash configs/tml-cisco.env
#
# Create the env file from configs/tml-cisco.env.example first. Start
# PrivateGPT before this container (./run-privategpt.bash).
#
# Written and tested by: Avraham Abel

ENV_FILE="${1:-configs/tml-cisco.env}"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  TML-Cisco Lab - Start the TML-Cisco Container\n'
printf '#%.0s' {1..50}; printf '\n\n'

if ! command -v docker >/dev/null 2>&1; then
    printf 'Docker is not installed. Install it with: sudo apt-get install docker.io\n' >&2
    exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
    printf 'Cannot find %s. Copy configs/tml-cisco.env.example and fill it in.\n' "$ENV_FILE" >&2
    exit 1
fi

# Load the settings into this shell's environment
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

for var in DOCKERHUB_USER BROKERHOSTPORT CLOUDUSERNAME CLOUDPASSWORD; do
    value="${!var}"
    if [ -z "$value" ] || [[ "$value" == \<* ]]; then
        printf '%s is not set in %s\n' "$var" "$ENV_FILE" >&2
        exit 1
    fi
done

IMAGE="$DOCKERHUB_USER/tml-cisco-networkcyberthreats-privategpt-amd64"
URL="http://localhost:${VIPERVIZPORT:-8080}/tml-cisco-network-privategpt-monitor.html?topic=cisco-network-preprocess,cisco-network-privategpt&offset=-1&groupid=&rollbackoffset=150&topictype=prediction&append=0&secure=1"

printf '== Starting %s ==\n' "$IMAGE"
docker run -d --net host \
    --env VIPERVIZPORT --env RUNTYPE \
    --env PGPTIP --env PGPTPORT --env PGPTROLLBACK \
    --env BROKERHOSTPORT --env KAFKAPRODUCETOPIC \
    --env CLOUDUSERNAME --env CLOUDPASSWORD \
    "$IMAGE" || exit 1

printf '\n== Dashboard URL (open it in a browser, then press START STREAMING) ==\n'
printf '%s\n' "$URL"
