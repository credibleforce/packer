#!/bin/bash

echo -e "Creating vmlist from running vagrant vms.\nThis list will be used by take and revert snapshot"
rm -f vmlist.txt; for vm in $(vmrun list | grep -Ev "^Total" | grep .vagrant); do echo $vm >> vmlist.txt; done
echo "Moving gateway to top...for reasons"
pfsense=$(grep pfsense vmlist.txt);
other=$(grep -v pfsense vmlist.txt);
echo $pfsense > vmlist.txt
for vm in $other; do echo $vm >> vmlist.txt; done
echo "Done."
cat vmlist.txt
