# Amazon Machine Images


Add your AWS credentials to a file like this:

```
$ cat ~/.aws/credentials 
[default]
aws_access_key_id=IBETHEACCESSKEY
aws_secret_access_key=ThiSisVerySSecret
```

Then build:


```
$ packer build centos7-hardened-aws.json
```


Official CentOS images on Amazon's EC2 Cloud:
https://wiki.centos.org/Cloud/AWS

## CIS notes

The images contain only one disk partition.


The images doesn't have firewalld installed since AWS images are firewalled by EC2 security groups.


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se

