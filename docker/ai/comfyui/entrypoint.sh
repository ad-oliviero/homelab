#!/bin/bash
set -e

OLD_HEAD=$(git rev-parse HEAD)
git pull origin master
NEW_HEAD=$(git rev-parse HEAD)

if [ "$OLD_HEAD" != "$NEW_HEAD" ]; then
    uv pip install --system --no-cache-dir -r requirements.txt
fi

exec python ./main.py --listen 0.0.0.0 $CLI_ARGS "$@"
