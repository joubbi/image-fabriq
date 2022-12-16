#!/usr/bin/env bash
packer init ubuntu-2004-cis.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build ubuntu-2004-cis.pkr.hcl 
