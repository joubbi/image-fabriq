# Centos 8 hardened image


This fabriq creates a hardened Centos 8.

The image is hardened with inspiration from the [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/) and [DevSec Hardening Framework](https://dev-sec.io/project/).


## Image details

SSH to port 22. Login: `user01` password: `changeme`

The password needs to be changed first time logging in.

SSH as root is not allowed.

Password for `root`: `Changeme123`

Bootloader username: `root` with password: `conoa`. This username can be changed in the file: (../ansible/files/user.cfg). Use `grub2-set-password` for that.

See the [kickstart file](./http/centos8-cis.ks) for more details.

### CIS notes


#### 1.11 Ensure system-wide crypto policy is FUTURE or FIPS

The system-wide crypto-policies followed by the crypto core components allow
consistently deprecating and disabling algorithms system-wide.
The individual policy levels (DEFAULT, LEGACY, FUTURE, and FIPS) are included in the
crypto-policies(7) package.

The LEGACY policy should not be used on a CIS level 1 compliant system.
On a CIS level 2 system either the FUTURE or FIPS policy should be used.

This is what happens if the FUTURE policy is used:

```
[user01@rhel8-hardened ~]$ git clone https://github.com/CISOfy/lynis
Cloning into 'lynis'...
fatal: unable to access 'https://github.com/CISOfy/lynis/': SSL certificate problem: EE certificate key too weak
```
This is how you solve it by changing the policy to DEFAULT:

```
[user01@rhel8-hardened ~]$ sudo update-crypto-policies --set default
Setting system policy to DEFAULT
Note: System-wide crypto policies are applied on application start-up.
It is recommended to restart the system for the change of policies
to fully take place.
[user01@rhel8-hardened ~]$ git clone https://github.com/CISOfy/lynis
Cloning into 'lynis'...
remote: Enumerating objects: 13829, done.
remote: Total 13829 (delta 0), reused 0 (delta 0), pack-reused 13829
Receiving objects: 100% (13829/13829), 7.22 MiB | 8.55 MiB/s, done.
Resolving deltas: 100% (10222/10222), done.
```

#### 5.3 Configure authselect

The CIS benchmark has this note: "Do not use authselect if your host is part of Red Hat Enterprise Linux Identity
Management or Active Directory."
Therefore `authselect` is not configured.


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se
