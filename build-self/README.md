# build-self

There are two ways to create your own image-fabriq in AWS.
1. Create a running instance with image-fabriq:  `$ ansible-playbook -i inventory ansible/build-image-fabriq-in-aws.yml`
2. Create an AMI containing image-fabriq: `$ packer build centos8-hardened-if-aws.json`

## build-image-fabriq-in-aws.yml
The file `build-image-fabriq-in-aws.yml` is a playbook for Ansible that creates and launches a machine in AWS containing image-fabriq.

Add your AWS credentials to a file like this:

```
$ cat ~/.boto 
[Credentials]
aws_access_key_id=IBETHEACCESSKEY
aws_secret_access_key=ThiSisVerySSecret
```
or pass them to boto/Ansible as environment variables.
See [ec2_instance_module](https://docs.ansible.com/ansible/latest/collections/community/aws/ec2_instance_module.html) for more information.

Then run the playbook:

`$ ansible-playbook -i inventory ansible/build-image-fabriq-in-aws.yml`

## centos8-hardened-if-aws.json
The file `centos8-hardened-if-aws.json` creates an AMI containing itself and its dependencies.


The created AMI is based on the official CentOS 8 AMI which is hardened the same way as centos8-hardened. The latest Ansible, packer and quemu are installed on it during build.
In addition to the binaries needed for image-fabriq, image-fabriq itself is copied to the home directory of the centos user.


Add your AWS credentials to a file like this:

```
$ cat ~/.aws/credentials 
[default]
aws_access_key_id=IBETHEACCESSKEY
aws_secret_access_key=ThiSisVerySSecret
```

Then build:

```
$ packer build centos8-hardened-if-aws.json
```

Once the build is ready, you have an Amazon Machine Image named `centos8-hardened-image-fabriq` in AWS.
This AMI can then be launced in a metal machine, for example `c5.metal`.
The reason for a metal machine is that we need a virtual machine with support for nested virtualization.

The username used by the CentOS image used is `centos`.

Login on the launced instance and build other images.


Official CentOS images on Amazon's EC2 Cloud:
https://wiki.centos.org/Cloud/AWS

### CIS notes

The images contain only one disk partition.


The image doesn't have firewalld installed since AWS images are firewalled by EC2 security groups.


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se

