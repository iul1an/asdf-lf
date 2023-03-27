#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/gokcehan/lf"
GH_RELEASES="https://api.github.com/repos/gokcehan/lf/releases"
TOOL_NAME="lf"
TOOL_TEST="lf --help"

fail() {
  echo -e "asdf-${TOOL_NAME}: $*" >&2
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sort -n
}

list_all_versions() {
  curl "${curl_opts[@]}" --url "$GH_RELEASES" |
    grep -oE "tag_name\": *\".{1,15}\"," | sed -e 's/tag_name\": \"v*//' -e 's/\",//' -e 's/^r\(.*\)/\1/' || fail "Could not fetch versions"
}

get_platform() {
  local platform
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case $platform in
    "linux") ;;
    "darwin") ;;
    *) fail "lf not supported on $platform" ;;
  esac
  echo "$platform"
}

get_arch() {
  local platform
  local arch
  platform="$(get_platform)"
  arch="$(uname -m)"

  case "$platform" in
    "linux")
      case "$arch" in
        "i?86") arch="386"  ;;
        "x86_64") arch="amd64" ;;
        "armv6l" | "armv7l") arch="arm"  ;;
        "arm64" | "aarch64" | "armv8l") arch="arm64" ;;
        *) fail "Arch $arch is not supported for lf" ;;
      esac
      ;;
    "darwin")
      case "$arch" in
        "arm64" | "x86_64") arch="amd64" ;;
        *) fail "Arch $arch is not supported for lf" ;;
      esac
      ;;
  esac
  echo "$arch"
}

download_release() {
  local version
  local filename
  local platform
  local arch
  local url

  version="$1"
  filename="$2"
  platform="$(get_platform)"
  arch="$(get_arch)"

  url="${GH_REPO}/releases/download/r${version}/lf-${platform}-${arch}.tar.gz"
  echo "* Downloading ${TOOL_NAME} release ${version}..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download ${url}"
}

install_version() {
  local install_type
  local version
  local install_path

  install_type="$1"
  version="$2"
  install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-${TOOL_NAME} supports release installs only"
  fi

  ( 
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."
    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
