#!/usr/bin/env bash

# This is a script that changes the quemu_binary path in json files for Packer.
# This is how a correct path looks like for Ubuntu: "qemu_binary": "/usr/bin/kvm",

if [ -f /usr/bin/kvm ]; then
    find ./ -iname "*.json" -type f -exec sed -i -e "s%/usr/libexec/qemu-kvm%/usr/bin/kvm%g" {} \;
fi

if [ -f /usr/libexec/qemu-kvm ]; then
    find ./ -iname "*.json" -type f -exec sed -i -e "s%/usr/bin/kvm%/usr/libexec/qemu-kvm%g" {} \;
fi


# Normally the above automagic should work, but in case you need to control it yourself:

# Uncomment this line if you run RHEL 8 or something else where the binary is /usr/libexec/qemu-kvm:
#find ./ -iname "*.json" -type f -exec sed -i -e "s%/usr/bin/kvm%/usr/libexec/qemu-kvm%g" {} \;

# Uncomment this line if you run something where the binary is /usr/bin/kvm:
#find ./ -iname "*.json" -type f -exec sed -i -e "s%/usr/libexec/qemu-kvm%/usr/bin/kvm%g" {} \;

