#!/usr/bin/env bash

# This script creates a file with information about used versions.

echo "---=== image-fabriq ===---"
echo
echo "Information gathered $(date)"
echo

echo
echo /etc/*_ver* /etc/*-rel*; cat /etc/*_ver* /etc/*-rel*
echo

echo uname -a
uname -a
echo

echo "packer --version"
packer --version
echo

echo "ansible --version"
ansible --version
echo

if [ -f /usr/bin/kvm ]; then
    echo "/usr/bin/kvm --version"
    /usr/bin/kvm --version
fi
if [ -f /usr/libexec/qemu-kvm ]; then
    echo "/usr/libexec/qemu-kvm --version"
    /usr/libexec/qemu-kvm --version
fi
echo

# The directory containing the files depends on your working directory.
# The below magis is needed for this to work from Ansible.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo ls -l ansible/files/
ls -l "$DIR"/build-self/ansible/files/
echo
