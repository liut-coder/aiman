#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${REPO_OWNER:-liut-coder}"
REPO_NAME="${REPO_NAME:-aiman}"
BRANCH="${BRANCH:-debian-docker}"
TARGET_DIR="${TARGET_DIR:-/opt/aiman}"
ARCHIVE_URL="https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/${BRANCH}"

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  SUDO="sudo"
else
  SUDO=""
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

is_debian_system() {
  if [ ! -r /etc/os-release ]; then
    return 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release
  [ "${ID:-}" = "debian" ]
}

detect_debian_codename() {
  if [ ! -r /etc/os-release ]; then
    return 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release

  if [ -n "${VERSION_CODENAME:-}" ]; then
    printf '%s\n' "${VERSION_CODENAME}"
    return
  fi

  case "${VERSION_ID:-}" in
    9) printf '%s\n' "stretch" ;;
    10) printf '%s\n' "buster" ;;
    11) printf '%s\n' "bullseye" ;;
    12) printf '%s\n' "bookworm" ;;
    13) printf '%s\n' "trixie" ;;
    *) return 1 ;;
  esac
}

backup_apt_sources_once() {
  if [ -e /etc/apt/sources.list ] && [ ! -e /etc/apt/sources.list.aiman.bak ]; then
    ${SUDO} cp /etc/apt/sources.list /etc/apt/sources.list.aiman.bak
  fi
}

disable_conflicting_debian_source_files() {
  if [ ! -d /etc/apt/sources.list.d ]; then
    return
  fi

  for file in /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
    if [ ! -f "${file}" ]; then
      continue
    fi

    if grep -Eq 'deb\.debian\.org|security\.debian\.org|archive\.debian\.org|download\.docker\.com|debian-security' "${file}"; then
      ${SUDO} mv "${file}" "${file}.disabled-by-aiman"
    fi
  done
}

write_debian_sources() {
  codename="$1"

  backup_apt_sources_once
  disable_conflicting_debian_source_files

  case "${codename}" in
    stretch|buster)
      cat <<EOF | ${SUDO} tee /etc/apt/sources.list >/dev/null
deb http://archive.debian.org/debian ${codename} main contrib non-free
deb http://archive.debian.org/debian-security ${codename}/updates main contrib non-free
EOF
      cat <<'EOF' | ${SUDO} tee /etc/apt/apt.conf.d/99aiman-archive >/dev/null
Acquire::Check-Valid-Until "false";
EOF
      ;;
    bullseye)
      cat <<EOF | ${SUDO} tee /etc/apt/sources.list >/dev/null
deb http://deb.debian.org/debian ${codename} main contrib non-free
deb http://deb.debian.org/debian ${codename}-updates main contrib non-free
deb http://deb.debian.org/debian-security ${codename}-security main contrib non-free
EOF
      ${SUDO} rm -f /etc/apt/apt.conf.d/99aiman-archive
      ;;
    bookworm|trixie)
      cat <<EOF | ${SUDO} tee /etc/apt/sources.list >/dev/null
deb http://deb.debian.org/debian ${codename} main contrib non-free non-free-firmware
deb http://deb.debian.org/debian ${codename}-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security ${codename}-security main contrib non-free non-free-firmware
EOF
      ${SUDO} rm -f /etc/apt/apt.conf.d/99aiman-archive
      ;;
    *)
      echo "Unsupported Debian codename: ${codename}" >&2
      return 1
      ;;
  esac
}

run_apt_update() {
  if ! need_cmd apt-get; then
    echo "apt-get 不可用，无法自动安装依赖。" >&2
    exit 1
  fi

  if is_debian_system; then
    codename="$(detect_debian_codename || true)"
    if [ -n "${codename}" ]; then
      echo "Normalizing Debian apt sources for ${codename}"
      write_debian_sources "${codename}"
    fi
  fi

  ${SUDO} apt-get update
}

ensure_base_packages() {
  if need_cmd curl && need_cmd tar; then
    return
  fi

  if ! need_cmd apt-get; then
    echo "curl/tar 缺失，且当前系统不是 apt 系，无法自动安装。" >&2
    exit 1
  fi

  run_apt_update
  ${SUDO} apt-get install -y curl tar ca-certificates gnupg lsb-release
}

ensure_supported_docker_debian() {
  if ! is_debian_system; then
    return
  fi

  codename="$(detect_debian_codename || true)"
  case "${codename}" in
    bullseye|bookworm|trixie)
      return
      ;;
    stretch|buster)
      echo "当前 Debian 版本 ${codename} 过旧，Docker 官方仓库已不再支持。" >&2
      echo "建议先升级到 Debian 11+，再执行一键脚本。" >&2
      exit 1
      ;;
  esac
}

ensure_docker_repo_prerequisites() {
  run_apt_update
  ${SUDO} apt-get install -y ca-certificates curl gnupg lsb-release
}

install_docker_from_official_repo() {
  codename="$1"

  ensure_docker_repo_prerequisites
  ${SUDO} mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | ${SUDO} gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  ${SUDO} chmod a+r /etc/apt/keyrings/docker.gpg

  cat <<EOF | ${SUDO} tee /etc/apt/sources.list.d/docker.list >/dev/null
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${codename} stable
EOF

  ${SUDO} apt-get update
  ${SUDO} apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

ensure_docker_stack() {
  if need_cmd docker; then
    return
  fi

  if ! need_cmd apt-get; then
    echo "docker 未安装，且当前系统不是 apt 系，无法自动安装。" >&2
    exit 1
  fi

  run_apt_update
  ensure_supported_docker_debian

  if is_debian_system; then
    codename="$(detect_debian_codename)"
    install_docker_from_official_repo "${codename}"
  else
    ${SUDO} apt-get install -y docker.io docker-compose || ${SUDO} apt-get install -y docker.io
  fi

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
