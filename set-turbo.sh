#!/usr/bin/env bash

# This is a script that changes the RAM and CPU in json files for Packer.
# A c5.metal machine in AWS has 96 vCPUs and 192 GiB RAM,
# we want to use the horse power we are paying for...



# Uncomment this line if you want turbo and use 20 vCPUs
find ./ -iname "*.json" -type f -exec sed -i -e "s%\"cpus\": .*%\"cpus\": \"20\",%g" {} \;

# Uncomment this line if you want turbo and use 40 GiB RAM
find ./ -iname "*.json" -type f -exec sed -i -e "s%\"memory\": .*%\"memory\": \"40960\",%g" {} \;

# Uncomment this line if you want to take it easy and use 2 vCPUs
#find ./ -iname "*.json" -type f -exec sed -i -e "s%\"cpus\": .*%\"cpus\": \"2\",%g" {} \;

# Uncomment this line if you want to take it easy and use 2 GiB RAM
#find ./ -iname "*.json" -type f -exec sed -i -e "s%\"memory\": .*%\"memory\": \"2048\",%g" {} \;

