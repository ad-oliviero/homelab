#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
 printf "This script must be run as root\n"
 exit 1
fi

VM_NAME="haos"
IMG_PATH="/media/storage/data/haos/haos.qcow2"
IMG_DIR=$(dirname "$IMG_PATH")
VARS_PATH="$IMG_DIR/haos_vars.fd"
EFI_PATH="$IMG_DIR/haos_efi.fd"

if [ ! -f "$IMG_PATH" ]; then
    printf "$IMG_PATH not found\n"
    read -p "Do you want to (d)ownload it or (a)bort? [d/a]: " choice
    if [[ "${choice,,}" != "d" ]]; then
        printf "Aborting as requested.\n"
        exit 0
    fi

    DL_URL=$(curl -s https://api.github.com/repos/home-assistant/operating-system/releases/latest | \
             grep "browser_download_url.*haos_generic-aarch64-.*\.qcow2\.xz" | \
             cut -d '"' -f 4)

    if [ -z "$DL_URL" ]; then
        printf "Error: Could not find the aarch64 qcow2.xz asset.\n"
        exit 1
    fi

    mkdir -p "$IMG_DIR"

    wget -O "${IMG_PATH}.xz" "$DL_URL"
    
    unxz -f "${IMG_PATH}.xz"
fi

if [ ! -f "$EFI_PATH" ]; then
    cp /usr/share/qemu-efi-aarch64/QEMU_EFI.fd "$EFI_PATH"
    truncate -s 64M "$EFI_PATH"
fi
if [ ! -f "$VARS_PATH" ]; then
    truncate -s 64M "$VARS_PATH"
fi


chown -R adri:adri "$IMG_DIR"

cp ./haos.service /etc/systemd/system/haos.service
systemctl daemon-reload
systemctl enable --now haos.service
