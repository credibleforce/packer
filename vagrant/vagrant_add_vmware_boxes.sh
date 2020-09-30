#!/bin/bash
echo "Starting vagrant update..."
for b in $(ls -1 *_vmware.box | awk -F _vmware '{print $1}'); do echo "Adding vagrant background job: ${b}"; vagrant box add ${b}_vmware.box --name vmware-${b} --force & done
echo "Waiting for all background jobs to complete..."
wait

echo "Complete."