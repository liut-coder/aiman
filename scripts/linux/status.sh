#!/usr/bin/env bash
set -euo pipefail

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose ps
  exit 0
fi

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose ps
  exit 0
fi

echo "docker compose / docker-compose 未安装或不可用" >&2
exit 1
