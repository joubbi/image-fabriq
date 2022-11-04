# Debian 10 image


This fabriq creates a Debian 10 image.


## Image details

SSH to port 22. Login: `user01` password: `changeme`

The password needs to be changed first time logging in.

There is no root account.


## GVM/OpenVAS 11

This image can for example be used for [GVM/OpenVAS 11](https://www.openvas.org/) with [gvm_install](https://github.com/yu210148/gvm_install) :

```
wget https://raw.githubusercontent.com/yu210148/gvm_install/master/install_gvm.sh
chmod +x install_gvm.sh
sudo -i
./install_gvm.sh
```


Author Information
------------------

Written by [Farid Joubbi](https://github.com/faridjoubbi) - Conoa AB - https://conoa.se

