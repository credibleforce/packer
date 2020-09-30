#!/bin/bash

PACKER_LOG=1 packer build  \
    --var iso_url=iso/windows_2016.iso \
    --var iso_checksum=sha256:1ce702a578a3cb1ac3d14873980838590f06d5b7101c5daaccbac9d73f1fb50f \
    box-config.json
