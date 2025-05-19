#!/bin/bash
set -e

cd "$(dirname "$0")/.."

# Directory to stage manually injected firmware blobs
STAGE_DIR="./firmware-manual/usr/lib/firmware"

# Create target directory structure
mkdir -p "${STAGE_DIR}/rtl_bt"

echo "[*] Downloading vendor and legacy firmware blobs..."

# --- Legacy Ralink firmware (extract from .deb) ---
echo "  - rt3070.bin (extracting from firmware-misc-nonfree)"
TMP_DIR=$(mktemp -d)
DEB_FILE="$TMP_DIR/firmware-misc-nonfree.deb"
curl -fsSL "https://ftp.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-misc-nonfree_20210315-3_all.deb" -o "$DEB_FILE"
dpkg-deb -x "$DEB_FILE" "$TMP_DIR"
cp "$TMP_DIR/lib/firmware/rt3070.bin" "${STAGE_DIR}/rt3070.bin" || echo "    [WARN] Failed to extract rt3070.bin"
rm -rf "$TMP_DIR"

# --- Realtek vendor blobs (resolve symlinks manually) ---

# rtl8723ds_fw.bin (actually rtlbt_fw)
echo "  - rtl_bt/rtl8723ds_fw.bin (renamed from rtlbt_fw)"
curl -fsSL "https://raw.githubusercontent.com/armbian/firmware/master/rtl_bt/rtlbt_fw" \
  -o "${STAGE_DIR}/rtl_bt/rtl8723ds_fw.bin" || echo "    [WARN] Failed to download rtl8723ds_fw.bin"

# rtl8723cs_cg_fw.bin (also points to rtlbt_fw)
echo "  - rtl_bt/rtl8723cs_cg_fw.bin (renamed from rtlbt_fw)"
curl -fsSL "https://raw.githubusercontent.com/armbian/firmware/master/rtl_bt/rtlbt_fw" \
  -o "${STAGE_DIR}/rtl_bt/rtl8723cs_cg_fw.bin" || echo "    [WARN] Failed to download rtl8723cs_cg_fw.bin"

# rtl8723ds_config.bin (symlink to rtl8723bs_config.bin)
echo "  - rtl_bt/rtl8723ds_config.bin (renamed from rtl8723bs_config.bin)"
curl -fsSL "https://raw.githubusercontent.com/armbian/firmware/master/rtl_bt/rtl8723bs_config.bin" \
  -o "${STAGE_DIR}/rtl_bt/rtl8723ds_config.bin" || echo "    [WARN] Failed to download rtl8723ds_config.bin"

# rtl8723cs_cg_config.bin (also symlink to rtl8723bs_config.bin)
echo "  - rtl_bt/rtl8723cs_cg_config.bin (renamed from rtl8723bs_config.bin)"
curl -fsSL "https://raw.githubusercontent.com/armbian/firmware/master/rtl_bt/rtl8723bs_config.bin" \
  -o "${STAGE_DIR}/rtl_bt/rtl8723cs_cg_config.bin" || echo "    [WARN] Failed to download rtl8723cs_cg_config.bin"

# --- Merge with existing firmware archive ---
OUT_TAR="output/firmware-volumio.tar.gz"
MERGE_DIR=$(mktemp -d)

echo "[*] Unpacking existing firmware bundle"
tar -xf "$OUT_TAR" -C "$MERGE_DIR"

echo "[*] Copying staged manual firmware into unpacked bundle"
cp -a firmware-manual/usr/lib/firmware/* "$MERGE_DIR/usr/lib/firmware/"

echo "[*] Repacking combined firmware bundle"
tar -C "$MERGE_DIR" -cf output/firmware-volumio.tar usr
gzip -f output/firmware-volumio.tar

echo "[+] Done. Output: $OUT_TAR"
