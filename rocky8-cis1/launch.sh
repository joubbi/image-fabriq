#!/usr/bin/env bash

cp image/rocky8-cis1.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name rocky8-cis1 --description "rocky8-cis1" --os-variant=rocky8.6 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/rocky8-cis1.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
