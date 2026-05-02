#!/bin/sh
set -eu

mkdir -p /app/config /app/data /app/log

if [ ! -s /app/config/config.json ]; then
  cp /app/docker/defaults/config.json /app/config/config.json
fi

if [ ! -s /app/data/list.json ]; then
  cp /app/docker/defaults/list.json /app/data/list.json
fi

exec "$@"
