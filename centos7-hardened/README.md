# Centos 7 hardened image


This fabriq creates a hardened Centos 7.

The image is hardened with inspiration from the [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/) and [DevSec Hardening Framework](https://dev-sec.io/project/).


## Image details

SSH to port 22. Login: `user01` password: `changeme`

The password needs to be changed first time logging in.

SSH as root is not allowed.

Password for `root`: `Changeme123`

Bootloader username: `root` with password: `conoa`. This username can be changed in the file: (../ansible/files/user.cfg). Use `grub2-set-password` for that.

See the [kickstart file](./http/centos7-hardened-ks.cfg) for more details.


### CIS notes

#### 1.8 Warning Banners

Presenting a warning message prior to the normal user login may assist in the prosecution
of trespassers on the computer system. Changing some of these login banners also has the
side effect of hiding OS version information and other detailed system information from
attackers attempting to target specific exploits at a system.

Banners are very site and organisation specific.
No banners are configured during image creation.


#### 4 Logging and Auditing

Section 4 of the CIS benchmark describes how to configure logging and auditing.
These settings are very site specific and therefore excluded in the image creation.

#### 4.1 Configure System Accounting (auditd)

System auditing, through auditd , allows system administrators to monitor their systems
such that they can detect unauthorized access or modification of data. By default, auditd
will audit system logins, account modifications, and authentication events. Events will be
logged to /var/log/audit/audit.log . The recording of these events will use a modest
amount of disk space on a system. If significantly more events are captured, additional on
system or off system storage may need to be allocated.

All the auditd settings are CIS level 2.

#### 4.2 Configure Logging

Logging services should be configured to prevent information leaks and to aggregate logs
on a remote server so that they can be reviewed in the event of a system compromise and
ease log analysis.

CIS recommends rsyslog software as a replacement for the syslogd daemon and
provides improvements over syslogd , such as connection-oriented (i.e. TCP) transmission
of logs, the option to log to database formats, and the encryption of log data en route to a
central logging server.

Ensure that logging software is configured in accordance with local site policy.

This is CIS level 1.

#### 5.3 Configure PAM

You are supposed to make changes in `password-auth` and `system-auth` in `/etc/pam.d/` according to CIS.
The proposed changes are outdated.
These two files are updated using Ansible. The files used are [here](../ansible/files/etc/pam.d/).
They are configured so that only local users are affected.

* [What is pam_faillock and how to use it in Red Hat Enterprise Linux?](https://access.redhat.com/solutions/62949)

* [How to setup account lockout policy using pam_faillock when system is an LDAP/IPA/AD client](https://access.redhat.com/solutions/880793)


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se
