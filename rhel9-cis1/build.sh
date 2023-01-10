#!/usr/bin/env bash
packer init rhel9-cis1.pkr.hcl
PACKER_CACHE_DIR=../packer_cache/ /usr/bin/packer build rhel9-cis1.pkr.hcl 
