#!/usr/bin/env bash

cp image/debian10.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name debian10 --description "debian10" --os-variant=debian10 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/debian10.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
