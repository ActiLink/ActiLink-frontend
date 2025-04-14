#!/usr/bin/env bash
DIR_PATH="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BACKEND_PATH="$DIR_PATH/../../ActiLink-backend/ActiLink"

docker compose \
    -f "$BACKEND_PATH/docker-compose.yml" \
    -f "$BACKEND_PATH/docker-compose.override.yml" \
    -f "$BACKEND_PATH/docker-compose.linux.yml" \
    up $@
