#!/bin/bash
set -e

source .env

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo $1 1>&2
}

# Build images for every desktop the openSUSE SDM845 repo publishes.
DESKTOPS="PHOSH PLAMO"
STATUS=0

for DESKTOP in ${DESKTOPS}; do
    infecho "==================== Building ${DESKTOP} ===================="

    # Per-desktop raw image name (downloaded, then consumed by the scripts below)
    OPENSUSE_RAW_FILE=openSUSE-Tumbleweed-ARM-${DESKTOP}-${DEVICE}.aarch64-$(date +"%Y.%m.%d").raw.xz
    export DESKTOP OPENSUSE_RAW_FILE

    if bash download-image.sh \
        && bash mount-image.sh \
        && bash bootloader.sh \
        && bash umount-image.sh \
        && bash extract-rootfs.sh; then
        infecho "✅ ${DESKTOP} build finished"
    else
        errecho "❌ ${DESKTOP} build failed; will continue with the next desktop"
        STATUS=1
        # Best-effort cleanup of any loop device / mount left behind
        bash umount-image.sh || true
    fi
done

infecho "Now you can install in your device"
infecho "Put your device in fastboot mode, and execute (pick the desktop and variant you want):"
for DESKTOP in ${DESKTOPS}; do
    infecho "  fastboot flash boot openSUSE-Tumbleweed-ARM-${DESKTOP}-<device><variant>.aarch64.boot.img"
    infecho "  fastboot -S 100M flash userdata openSUSE-Tumbleweed-ARM-${DESKTOP}-<device>.aarch64.root.img"
done
infecho "  fastboot erase dtbo"

exit $STATUS
