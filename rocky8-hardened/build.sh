#!/usr/bin/env bash
packer init rocky8-hardened.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build rocky8-hardened.pkr.hcl 
