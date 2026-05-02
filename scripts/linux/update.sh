#!/usr/bin/env sh
set -eu

git fetch origin
git switch debian-docker
git pull --ff-only

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  docker compose up -d --build
  exit 0
fi

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose up -d --build
  exit 0
fi

echo "docker compose / docker-compose 未安装或不可用" >&2
exit 1
