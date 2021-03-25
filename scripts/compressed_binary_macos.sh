#!/bin/bash
set -e

BUILD_SCRIPT="scripts/build_binary_macos.sh"
BINARIES_DIR="binaries"
OUTPUT_DIR="binaries"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${DIR}/.."

/bin/bash "${ROOT_DIR}/${BUILD_SCRIPT}" "$1"

cd "${ROOT_DIR}/${BINARIES_DIR}"

rm -f "${ROOT_DIR}/${OUTPUT_DIR}"/*.zip

for frmwk in ./*.xcframework; do
  name="${frmwk%.*}"
  PODS_ZIP_FILE="${ROOT_DIR}/${OUTPUT_DIR}/${name}.Pods-Binary.zip"
  SPM_ZIP_FILE="${ROOT_DIR}/${OUTPUT_DIR}/${name}.SPM-Binary.zip"
  zip -r "${PODS_ZIP_FILE}" "${frmwk}"
  zip -r "${SPM_ZIP_FILE}" "${frmwk}"/*
  shasum -a 256 --tag "${PODS_ZIP_FILE}"
  swiftsum=$(swift package compute-checksum "${SPM_ZIP_FILE}")
  echo "Swift checksum: ${swiftsum}"
done

exit 0
