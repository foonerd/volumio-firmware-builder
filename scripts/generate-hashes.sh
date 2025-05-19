#!/bin/bash
set -e

cd "$(dirname "$0")/.."

TARGET="output/firmware-volumio.tar.gz"
BASENAME=$(basename "$TARGET") # includes .tar.gz
DIRNAME=$(dirname "$TARGET")   # should be 'output'

if [ ! -f "$TARGET" ]; then
  echo "[ERROR] File not found: $TARGET"
  exit 1
fi

echo "[*] Generating hash files in $DIRNAME for $BASENAME"

# Change into the output directory for clean relative filenames
(
  cd "$DIRNAME"
  sha1sum   "$BASENAME" > "${BASENAME%.tar.gz}.sha1sum.txt"
  sha256sum "$BASENAME" > "${BASENAME%.tar.gz}.sha256sum.txt"
  md5sum    "$BASENAME" > "${BASENAME%.tar.gz}.md5sum.txt"
)

echo "[+] Created:"
echo "    ${DIRNAME}/${BASENAME%.tar.gz}.sha1sum.txt"
echo "    ${DIRNAME}/${BASENAME%.tar.gz}.sha256sum.txt"
echo "    ${DIRNAME}/${BASENAME%.tar.gz}.md5sum.txt"
