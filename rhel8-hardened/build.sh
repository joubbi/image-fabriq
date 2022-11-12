#!/usr/bin/env bash
packer init rhel8-hardened.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build rhel8-hardened.pkr.hcl 
