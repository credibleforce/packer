#!/bin/bash
# rm -f vmlist; for vm in $(vmrun list | grep -Ev "^Total"); do echo $vm >> vmlist; done

echo "Rebooting all vagrant vms"
for vm in $(cat vmlist.txt); do vmrun reset "$vm"; done
exit 0
