#!/bin/bash
set -e

TARGET_NAME="firmware-volumio.tar.gz"
OUTDIR="$(pwd)/output"

mkdir -p "$OUTDIR"

docker build -t volumio-fw-builder .

docker run --rm \
  -v "$OUTDIR":/out \
  -v "$(pwd)/firmware-list.txt":/build/firmware-list.txt \
  volumio-fw-builder
