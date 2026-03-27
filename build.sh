#!/bin/bash

set -e # stop if any command fails

echo "Assembling bootloader..."
nasm -f bin Boot1.asm -o boot1.bin

echo "Assembling stage 2..."
nasm -f bin Stage2.asm -o stage2.bin

echo "Creating disk image..."
dd if=/dev/zero of=os.img bs=512 count=2880

echo "Writing bootloader..."
dd if=boot1.bin of=os.img bs=512 count=1 conv=notrunc

echo "Writing stage 2..."
dd if=stage2.bin of=os.img bs=512 seek=1 conv=notrunc

echo "Running in QEMU..."
qemu-system-i386 -drive format=raw,file=os.img
