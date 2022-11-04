#!/usr/bin/env bash

cp image/debian11.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name debian11 --description "debian11" --os-variant=debian11 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/debian10.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
