#!/bin/bash
set -e

git pull origin master

pip install --no-cache-dir -r requirements.txt

exec python main.py --listen 0.0.0.0 $CLI_ARGS "$@"
