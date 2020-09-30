#!/bin/bash

PACKER_LOG=1 packer build \
  --var iso_url=iso/windows_2008_r2.iso \
  --var iso_checksum=sha256:30832ad76ccfa4ce48ccb936edefe02079d42fb1da32201bf9e3a880c8ed6312 \
  box-config.json