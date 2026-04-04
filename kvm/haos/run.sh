#!/bin/bash
set -e

VM_NAME="haos"
IMG_PATH="/media/storage/data/haos/haos.qcow2"
IMG_DIR=$(dirname "$IMG_PATH")
VARS_PATH="$IMG_DIR/haos_vars.fd"
EFI_PATH="$IMG_DIR/haos_efi.fd"

qemu-system-aarch64 \
    -M virt \
    -accel kvm \
    -cpu host \
    -smp 2 \
    -m 2048 \
    -drive if=pflash,format=raw,readonly=on,file="$EFI_PATH" \
    -drive if=pflash,format=raw,file="$VARS_PATH" \
    -drive file="$IMG_PATH",if=none,id=drive0,format=qcow2 \
    -device virtio-blk-pci,drive=drive0 \
    -netdev user,id=net0,hostfwd=tcp:172.17.0.1:8123-:8123 \
    -device virtio-net-pci,netdev=net0 \
    -display none \
    -serial telnet:localhost:4321,server,nowait
