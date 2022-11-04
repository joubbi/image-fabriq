#!/usr/bin/env bash

cp image/rhel8-hardened.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name rhel8-hardened --description "rhel8-hardened" --os-variant=rhel8.0 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/rhel8-hardened.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
