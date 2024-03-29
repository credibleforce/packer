#!/bin/bash
echo "Starting vagrant update..."
for box in $(ls -f "../windows/" | grep windows_); do vagrant box add ../windows/$box/builds/vmware-${box}.box --name vmware-${box} --force; done
for box in $(ls -f "../linux/" | grep -v "\."); do vagrant box add ../linux/$box/builds/vmware-${box}.box --name vmware-${box} --force; done
echo "Waiting for all background jobs to complete..."
wait

echo "Complete."
