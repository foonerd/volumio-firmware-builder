#!/bin/bash
set -e

mkdir -p /out/lib/firmware

while IFS= read -r fw; do
    [[ "$fw" =~ ^#.*$ || -z "$fw" ]] && continue

    src="/build/linux-firmware/$fw"
    if [ -f "$src" ]; then
        echo "Copying $fw"
        mkdir -p "/out/lib/firmware/$(dirname "$fw")"
        cp "$src" "/out/lib/firmware/$fw"
    else
        echo "Warning: $fw not found"
    fi
done < /build/firmware-list.txt

cd /out
tar -czvf firmware-volumio.tar.gz lib/firmware
