#!/bin/bash

mkdir -p generated

set -a
source "$HOME/homelab/.env"
source .env
set +a

envsubst < continuwuity.template.toml > generated/continuwuity.toml
envsubst < livekit.template.yaml > generated/livekit.yaml
envsubst < coturn.template.conf > generated/coturn.conf
envsubst < element_config.template.json > generated/element_config.json

sudo -E docker compose up -d
