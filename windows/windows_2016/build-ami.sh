#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -vmware|--vmware)
      BUILD_VMWARE="vmware-iso"
      shift
      ;;
    -virtualbox|--virtualbox)
      BUILD_VBOX="virtualbox-iso"
      shift
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ -n $BUILD_VMWARE && -n $BUILD_VBOX ]]; then
  ONLY="$BUILD_VBOX,$BUILD_VMWARE"
elif [[ -n $BUILD_VMWARE ]]; then
  ONLY="$BUILD_VMWARE"
elif [[ -n $BUILD_VBOX ]]; then
  ONLY="$BUILD_VBOX"
else
  ONLY="$BUILD_VBOX,$BUILD_VMWARE"
fi

PACKER_LOG=1 packer build  \
    -only=$ONLY \
    -var iso_url=iso/windows_2016.iso \
    -var iso_checksum=sha256:1ce702a578a3cb1ac3d14873980838590f06d5b7101c5daaccbac9d73f1fb50f \
    box-config-ami.json
