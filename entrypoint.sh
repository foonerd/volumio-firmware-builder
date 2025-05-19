#!/bin/bash
set -e

mkdir -p /out/usr/lib/firmware

while IFS= read -r fw; do
    [[ "$fw" =~ ^#.*$ || -z "$fw" ]] && continue

    src="/build/linux-firmware/$fw"
    if [ -f "$src" ]; then
        echo "Copying $fw"
        mkdir -p "/out/usr/lib/firmware/$(dirname "$fw")"
        cp "$src" "/out/usr/lib/firmware/$fw"
    else
        echo "Warning: $fw not found"
    fi
done < /build/firmware-list.txt

cd /out
tar -czvf firmware-volumio.tar.gz usr
