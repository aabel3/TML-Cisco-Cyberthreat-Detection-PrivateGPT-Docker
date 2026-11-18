#!/bin/bash
#
# run-privategpt.bash
# TML-Cisco cyberthreat detection lab
#
# Starts the PrivateGPT container (CPU only) that the TML-Cisco container
# sends its processed data to for AI analysis.
#
# Usage:  ./run-privategpt.bash [port]
# Example: ./run-privategpt.bash 8001
#
# Written and tested by: Avraham Abel

PORT="${1:-8001}"
IMAGE="maadsdocker/tml-privategpt-no-gpu-amd64"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  TML-Cisco Lab - Start PrivateGPT\n'
printf '#%.0s' {1..50}; printf '\n\n'

if ! command -v docker >/dev/null 2>&1; then
    printf 'Docker is not installed. Install it with: sudo apt-get install docker.io\n' >&2
    exit 1
fi

printf '== Starting %s on port %s ==\n' "$IMAGE" "$PORT"
docker run -d -p "$PORT:8001" --env PORT=8001 --env GPU=0 --env CUDA_VISIBLE_DEVICES=0 "$IMAGE" || exit 1

printf '\nPrivateGPT is starting. Check it with: docker container ls\n'
