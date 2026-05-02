#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${REPO_OWNER:-liut-coder}"
REPO_NAME="${REPO_NAME:-aiman}"
BRANCH="${BRANCH:-debian-docker}"
TARGET_DIR="${TARGET_DIR:-/opt/aiman}"
ARCHIVE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${BRANCH}.tar.gz"

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

ensure_base_packages() {
  if need_cmd curl && need_cmd tar; then
    return
  fi

  if ! need_cmd apt-get; then
    echo "curl/tar 缺失，且当前系统不是 apt 系，无法自动安装。" >&2
    exit 1
  fi

  ${SUDO} apt-get update
  ${SUDO} apt-get install -y curl tar ca-certificates
}

ensure_docker_stack() {
  if need_cmd docker; then
    return
  fi

  if ! need_cmd apt-get; then
    echo "docker 未安装，且当前系统不是 apt 系，无法自动安装。" >&2
    exit 1
  fi

  ${SUDO} apt-get update
  ${SUDO} apt-get install -y docker.io docker-compose || ${SUDO} apt-get install -y docker.io

  if need_cmd systemctl; then
    ${SUDO} systemctl enable --now docker || true
  fi
}

tmp_dir="$(mktemp -d)"
src_dir="${tmp_dir}/src"
persist_dir="${tmp_dir}/persist"
archive_file="${tmp_dir}/repo.tar.gz"

cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

ensure_base_packages
ensure_docker_stack

mkdir -p "${src_dir}" "${persist_dir}"

echo "Downloading ${ARCHIVE_URL}"
curl -fsSL "${ARCHIVE_URL}" -o "${archive_file}"

tar -xzf "${archive_file}" -C "${src_dir}"

extracted_dir="$(find "${src_dir}" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [ -z "${extracted_dir}" ]; then
  echo "下载包解压失败，未找到源码目录。" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

for name in config data log; do
  if [ -e "${TARGET_DIR}/${name}" ]; then
    cp -a "${TARGET_DIR}/${name}" "${persist_dir}/"
  fi
done

find "${TARGET_DIR}" -mindepth 1 -maxdepth 1 \
  ! -name config \
  ! -name data \
  ! -name log \
  -exec rm -rf {} +

cp -a "${extracted_dir}/." "${TARGET_DIR}/"

for name in config data log; do
  if [ -e "${persist_dir}/${name}" ]; then
    rm -rf "${TARGET_DIR:?}/${name}"
    cp -a "${persist_dir}/${name}" "${TARGET_DIR}/"
  fi
done

mkdir -p "${TARGET_DIR}/config" "${TARGET_DIR}/data" "${TARGET_DIR}/log"

cd "${TARGET_DIR}"
chmod +x ./scripts/linux/*.sh

echo "Deploying in ${TARGET_DIR}"
sh ./scripts/linux/deploy.sh

echo
echo "Done."
echo "Project dir: ${TARGET_DIR}"
echo "Status: sh ./scripts/linux/status.sh"
echo "Logs:   sh ./scripts/linux/logs.sh"
