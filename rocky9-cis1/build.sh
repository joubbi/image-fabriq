#!/usr/bin/env bash
packer init rocky9-cis1.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build rocky9-cis1.pkr.hcl 
