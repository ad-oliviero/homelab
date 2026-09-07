#!/bin/bash
set -e

VM_NAME="haos"
IMG_PATH="/home/adri/storage/data/haos/haos.qcow2"
IMG_DIR=$(dirname "$IMG_PATH")
VARS_PATH="$IMG_DIR/haos_vars.fd"
EFI_PATH="$IMG_DIR/haos_efi.fd"

# device ids lsusb
# USB_ARGS="-device qemu-xhci -device usb-host,vendorid=0x10c4,productid=0xea60"

qemu-system-aarch64 \
    -M virt \
    -accel kvm \
    -cpu host \
    -smp 2 \
    -m 3192 \
    -drive if=pflash,format=raw,readonly=on,file="$EFI_PATH" \
    -drive if=pflash,format=raw,file="$VARS_PATH" \
    -drive file="$IMG_PATH",if=none,id=drive0,format=qcow2 \
    -device virtio-blk-pci,drive=drive0 \
    ${USB_ARGS:-} \
    -netdev user,id=net0,hostfwd=tcp:172.17.0.1:8123-:80 \
    -device virtio-net-pci,netdev=net0 \
    -display none \
    -serial telnet:localhost:4321,server,nowait
