#!/bin/bash
export POWERSHELL_VERSION=""
PACKER_LOG=1 packer build \
  --var iso_url=iso/windows_7.iso \
  --var iso_checksum=sha256:2c16c73388a5c02a0ec4cd8b9e5c14ba28b7b45d13d0c9c7d44459feecc0385f \
  box-config-ami.json

