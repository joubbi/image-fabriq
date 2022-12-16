#!/usr/bin/env bash

cp image/ubuntu-2004-cis.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name ubuntu-2004-cis --description "ubuntu-2004-cis" --os-variant=ubuntu20.04 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/ubuntu-2004-cis.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
