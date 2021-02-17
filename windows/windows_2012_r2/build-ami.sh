#!/bin/bash

PACKER_LOG=1 packer build \
  --var iso_url=iso/windows_2012_r2.iso \
  --var iso_checksum=sha256:6612b5b1f53e845aacdf96e974bb119a3d9b4dcb5b82e65804ab7e534dc7b4d5 \
  box-config-ami.json