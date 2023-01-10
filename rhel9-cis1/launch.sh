#!/usr/bin/env bash

cp image/rhel9-cis1.qcow2 /var/lib/libvirt/images/

virt-install --connect qemu:///system --name rhel9-cis1 --description "rhel9-cis1" --os-variant=rhel9.0 --memory 2048 --vcpus=2 --disk path=/var/lib/libvirt/images/rhel9-cis1.qcow2,device=disk,bus=virtio,format=qcow2 --import --noautoconsole

echo
echo "sudo virsh net-dhcp-leases default"
echo
