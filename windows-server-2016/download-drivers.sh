#!/bin/sh

rm -rf drivers.tmp
mkdir -p drivers.tmp
# see https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html
wget -P drivers.tmp https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.172-1/virtio-win-0.1.172.iso
7z x -odrivers.tmp drivers.tmp/virtio-win-*.iso
7z a drivers.tmp/virtio-2012-r2.zip drivers.tmp/Balloon/2k12R2/amd64 drivers.tmp/vioserial/2k12R2/amd64
7z a drivers.tmp/virtio-10.zip drivers.tmp/Balloon/w10/amd64
7z a drivers.tmp/virtio-2016.zip drivers.tmp/Balloon/2k16/amd64
7z a drivers.tmp/virtio-2019.zip drivers.tmp/Balloon/2k19/amd64
mv drivers.tmp drivers