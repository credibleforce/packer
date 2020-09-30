#!/bin/bash

PACKER_LOG=1 packer build \
  --var iso_url=iso/windows_10.iso \
  --var iso_checksum=sha256:f1a4f2176259167cd2c8bf83f3f5a4039753b6cc28c35ac624da95a36e9620fc \
  box-config.json

