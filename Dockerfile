FROM debian:bookworm

RUN apt update && apt install -y --no-install-recommends \
    git ca-certificates binutils findutils xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

COPY entrypoint.sh /build/
ENTRYPOINT ["bash", "/build/entrypoint.sh"]
