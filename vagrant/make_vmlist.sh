#!/bin/bash

echo -e "Creating vmlist from running vagrant vms.\nThis list will be used by take and revert snapshot"
rm -f vmlist; for vm in $(vmrun list | grep -Ev "^Total" | grep .vagrant); do echo $vm >> vmlist; done
echo "Moving gateway to top...for reasons"
pfsense=$(grep pfsense vmlist);
other=$(grep -v pfsense vmlist);
echo $pfsense > vmlist
for vm in $other; do echo $vm >> vmlist; done
echo "Done."
cat vmlist
