#!/usr/bin/env bash
packer init rhel8-cis1.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build rhel8-cis1.pkr.hcl 
