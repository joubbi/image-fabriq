#!/usr/bin/env bash
packer init ubuntu-2204.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build ubuntu-2204.pkr.hcl 
