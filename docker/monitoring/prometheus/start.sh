#!/bin/bash
set -euo pipefail

mkdir -p generated

set -a
source "$HOME/homelab/.env"
set +a

envsubst < prometheus.template.yml > generated/prometheus.yml

sudo -E docker compose up -d "$@" --force-recreate
