# Volumio Firmware Bundle Builder

A Docker-based tool to extract a precise set of firmware blobs from the official `linux-firmware` Git repository, preserving kernel-expected directory structure, and package them into a tarball for use in Volumio OS builds.

## Purpose

Volumio and related Raspbian-derived distributions may lack complete non-free firmware coverage (e.g., for Realtek, Ralink, MediaTek, Intel). This tool builds a curated firmware archive (`firmware-volumio.tar.gz`) for Raspberry Pi target systems, intended to be uploaded to:

https://github.com/volumio/volumio3-os-static-assets/tree/master/firmwares/<target>/

## Features

- Pulls latest firmware from upstream `linux-firmware.git`
- Supports exact firmware blob paths (e.g., `rtlwifi/rtl8192cufw_TMSC.bin`)
- Output: `output/firmware-volumio.tar.gz`
- Validates required firmware by analyzing kernel modules (`modinfo`)
- Supports optional manual injection of vendor-only or deprecated firmware
- Supports generation of SHA1, SHA256, and MD5 checksums

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-org/volumio-firmware-builder.git
cd volumio-firmware-builder
```

### 2. Edit `firmware-list.txt`

List required firmware files **with relative paths**, e.g.:

```
rt2870.bin
rt3070.bin
rtlwifi/rtl8192cufw_TMSC.bin
rtl_bt/rtl8821c_config.bin
iwlwifi-8265-36.ucode
```

### 3. Build the bundle

```bash
./build.sh
```

Output will be:

```
output/firmware-volumio.tar.gz
```

## Optional: Auto-Generate Firmware List

On a Raspberry Pi target running Volumio:

```bash
sudo ./scripts/check-firmware.sh
```

This will produce:

- `required-firmware.txt`
- `available-firmware.txt`
- `missing-firmware.txt`

Manually curate `missing-firmware.txt` to update `firmware-list.txt`.

## Manual Firmware Injection

Some firmware blobs are not present in the official `linux-firmware.git` tree and must be added manually. These include:

- `rt3070.bin` (legacy Ralink)
- `rtl8723cs_cg_config.bin`, `rtl8723cs_cg_fw.bin`
- `rtl8723ds_config.bin`, `rtl8723ds_fw.bin`

Use the provided script to inject them into the final archive:

```bash
./scripts/manual-inject.sh
```

This will:

- Download vendor or legacy firmware
- Extract or fetch files from reliable sources (Armbian, Debian snapshot)
- Append them into `output/firmware-volumio.tar.gz`
- Regenerate `firmware-volumio.tar.gz`

## Generate Hashes

After creating the bundle, you can generate checksum files:

```bash
./scripts/generate-hashes.sh
```

This creates:

- `output/firmware-volumio.sha1sum.txt`
- `output/firmware-volumio.sha256sum.txt`
- `output/firmware-volumio.md5sum.txt`

All files follow standard `sum` format with filename included for integrity checks.

## Upload to Volumio

Manually upload `firmware-volumio.tar.gz` to:

https://github.com/volumio/volumio3-os-static-assets/tree/master/firmwares/\<target\>/

Ensure your build logic extracts it to `/lib/firmware` in the target rootfs.

## License

MIT License – see [LICENSE](./LICENSE)
