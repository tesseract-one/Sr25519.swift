#!/bin/bash
set -e

LIB_NAME="sr25519crust"
SOURCES_DIR="rust"
HEADERS_DIR="include"
OUTPUT_DIR="$( cd "$1" && pwd )"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${DIR}/.."

HAS_CARGO_IN_PATH=`command -v cargo >/dev/null 2>&1; echo $?`

if [ "${HAS_CARGO_IN_PATH}" -ne 0 ]; then
    source $HOME/.cargo/env
fi

if [ "$2" == "debug" ]; then
  RELEASE=""
  CONFIGURATION="debug"
else
  RELEASE="--release"
  CONFIGURATION="release"
fi

mkdir -p "${OUTPUT_DIR}/include"
mkdir -p "${OUTPUT_DIR}/lib"

cd "${ROOT_DIR}/${SOURCES_DIR}"
  
cargo build --lib $RELEASE

cp -f "target/${TARGET_PATH}/${CONFIGURATION}/lib${LIB_NAME}."* "${OUTPUT_DIR}/lib/"
cp -fr "${HEADERS_DIR}"/* "${OUTPUT_DIR}/include/"

exit 0
