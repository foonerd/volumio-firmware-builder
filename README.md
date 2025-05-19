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

### Optional: Auto-Generate Firmware List

On a Raspberry Pi target running Volumio:

```bash
./scripts/validate-paths.sh > firmware-list.txt
```

## Upload to Volumio

Manually upload `firmware-volumio.tar.gz` to:

https://github.com/volumio/volumio3-os-static-assets/tree/master/firmwares/<target>/

## License

MIT License – see [LICENSE](./LICENSE)
