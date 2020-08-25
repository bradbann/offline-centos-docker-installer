#!/bin/bash

mkdir -p packages/bin/ packages/scripts/
# Acquire docker-binary

curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.12.tgz | tar xzvf -
mv -f docker packages/

# Acquire docker-compose

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

function get_release_bin() {
  local REPO=$1
  local FNAME=$2

  VERSION=$(get_latest_release "${REPO}")
  FILE_NAME=${FNAME//\[VERSION\]/${VERSION}}
  curl -L "https://github.com/${REPO}/releases/download/${VERSION}/${FILE_NAME}" -o ${FILE_NAME}

  TMP_TARGET_DIR=$(mktemp -d `pwd`/target_XXXXXXXX)
  cp ${FILE_NAME} ${TMP_TARGET_DIR}/

  rm -rf ${TMP_TARGET_DIR}
}

get_release_bin "docker/compose" "docker-compose-Linux-x86_64"
mv docker-compose-Linux-x86_64 packages/bin/docker-compose
