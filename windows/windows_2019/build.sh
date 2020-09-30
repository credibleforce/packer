#!/bin/bash

PACKER_LOG=1 packer build \
  --var iso_url=iso/windows_2019.iso \
  --var iso_checksum=sha256:549bca46c055157291be6c22a3aaaed8330e78ef4382c99ee82c896426a1cee1 \
  box-config.json
