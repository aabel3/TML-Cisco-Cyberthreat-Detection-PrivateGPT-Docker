#!/bin/bash
#
# verify-solution.bash
# TML-Cisco cyberthreat detection lab
#
# Runs the checks for the lab on the VM:
#   1. Docker is installed and the daemon is reachable
#   2. The PrivateGPT container is running
#   3. The TML-Cisco container is running
#   4. PrivateGPT and the dashboard answer on their ports
#
# Usage:  ./verify-solution.bash [dashboard_port] [privategpt_port]
# Example: ./verify-solution.bash 8080 8001
#
# Written and tested by: Avraham Abel

DASH_PORT="${1:-8080}"
GPT_PORT="${2:-8001}"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  TML-Cisco Lab - Solution Check\n'
printf '#%.0s' {1..50}; printf '\n\n'

PASS=0
FAIL=0

check() {
    # check "description" command...
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then
        printf '[ OK ]   %s\n' "$desc"
        PASS=$((PASS + 1))
    else
        printf '[FAIL]   %s\n' "$desc" >&2
        FAIL=$((FAIL + 1))
    fi
}

printf '== Containers ==\n'
docker container ls 2>&1
printf '\n'

printf '== Checks ==\n'
check "Docker is installed" command -v docker
check "Docker daemon is reachable" docker info
check "PrivateGPT container is running" \
    bash -c "docker ps --format '{{.Image}}' | grep -q 'tml-privategpt'"
check "TML-Cisco container is running" \
    bash -c "docker ps --format '{{.Image}}' | grep -q 'tml-cisco-network'"
check "PrivateGPT port $GPT_PORT is open" timeout 3 bash -c "</dev/tcp/127.0.0.1/$GPT_PORT"
check "Dashboard port $DASH_PORT is open" timeout 3 bash -c "</dev/tcp/127.0.0.1/$DASH_PORT"

if command -v curl >/dev/null 2>&1; then
    check "HTTP 200 from the dashboard on port $DASH_PORT" \
        bash -c "[ \"\$(curl -s -o /dev/null -m 5 -w '%{http_code}' http://localhost:$DASH_PORT/tml-cisco-network-privategpt-monitor.html)\" = 200 ]"
else
    printf '[SKIP]   curl not installed, dashboard check skipped\n'
fi

printf '\nResult: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
