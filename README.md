# image-fabriq

This is a factory for operating system images.

- [Amazon Machine Images](./aws/README.md)

- [Debian 10](./debian10/README.md)

- [Debian 10 Hardened](./debian10-hardened/README.md)

- [CentOS 7 Hardened](./centos7-hardened/README.md)

- [CentOS 8 Hardened](./centos8-hardened/README.md)

- [Red Hat Enterprise Linux 7 Hardened](./rhel7-hardened/README.md)

- [Red Hat Enterprise Linux 8 Hardened](./rhel8-hardened/README.md)


## Requirements

### KVM

The images are built in a virtual machine. The virtual machine is provided by [KVM](https://www.linux-kvm.org/).

Install KVM on your server. The installation varies a bit depending on your operating system.

Here is a guide for [Installing KVM/QEMU on CentOS 8 for Virtualization](https://linuxhint.com/kvm_qemu_centos8_install/).

***Note that KVM requires hardware virtualization.***
This might be a problem if you are running in a virtual environment that doesn't support nested virtualization.

You might have to edit the .json file in each fabriq in case the qemu binary is not found in the default location.
Replace the `"qemu_binary": "/usr/bin/kvm"` with a value that matches your KVM installation.
For RHEL/CentOS 8 it probably should look like this: `"qemu_binary": "/usr/libexec/qemu-kvm",`.
Use the script `set-kvm-path.sh` to do this automatically.

### Packer

You need to install [HashiCorp Packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install).
Packer is the tool used to create the images.

##### Installing Packer on CentOS/RHEL

```
$ sudo yum install -y yum-utils
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
$ sudo yum -y install packer
```

### Ansible

You need to install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
Ansible is a tool used to customize the image during creation.

##### Installing Ansible on RHEL 8

```
$ sudo subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
$ sudo yum install ansible
```

#### Additional Ansible roles and collections

You will probably need to install additional roles and/or collections for Ansible depending on which image you create.


##### DevSec Hardening Framework

The hardened images are hardened using the [os_hardening role](https://github.com/dev-sec/ansible-collection-hardening/tree/master/roles/os_hardening) and the [ssh_hardening role](https://github.com/dev-sec/ansible-collection-hardening/tree/master/roles/ssh_hardening) from the [DevSec Hardening Framework](https://dev-sec.io/).

install the [devsec.hardening](https://galaxy.ansible.com/devsec/hardening) Ansible collection:
`ansible-galaxy collection install devsec.hardening`

##### AIDE

[AIDE](https://aide.github.io/) is istalled on the hardened images using the Ansible role  [ahuffman.aide](https://github.com/ahuffman/ansible-aide). This role is included with image-fabriq.


## Creating an image

A normal build:
```
$ cd fabriq
$ ./build.sh
```

## Launching an image from image-fabriq

```
$ sudo ./lauch
```
Wait 30 seconds or so for the machine to boot.
Then do this to see the IP address of the machine:
```
$ sudo virsh net-dhcp-leases default
```
Now it's possible to SSH into the machine.


If you need a terminal, you can tunnel the TCP port used by spice over SSH:
```
ssh -L 5901:localhost:5901 -i awssshkey.pem centos@34.253.63.100
```

If you want Virtual Machine Manager:
```
virt-manager --connect qemu+ssh://centos@34.253.63.100/system?keyfile=awssshkey.pem
```

### Log

The build creates a logfile `/var/log/image-fabriq.log` inside the created image.
This file contains information about the different tool versions used during image creation.


### Debugging

A debug build:
```
$ PACKER_LOG=1 packer build centos7-hardened.json
```

You can connect with a VNC viewer to see the build process.
Packer uses a random TCP port for the VNC connection, which is open only on localhost.
You can see the port number in the output from Packer.


## Known issues

In some cases the virtual image can't bring up it's network interface in KVM.
`/var/log/messages` shows the following error:
```
NetworkManager: <info> op="connection-activate" name="eth0" result="fail" reason="No suitable device found for this connection (device eth0 not available because profile is not compatible with device (permanent MAC address doesn't match))."
```
For some reason the MAC address in the connection profile and the interface doesn't match.
Resolution:
```
nmcli con show eth0 | grep 802-3-ethernet.mac-address:
ip link show eth0           # This gives you the MAC that you need for the next command.
nmcli con modify eth0 802-3-ethernet.mac-address 52:54:00:xx:xx:xx
nmcli con up eth0
```

See: https://access.redhat.com/solutions/3667791


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se
