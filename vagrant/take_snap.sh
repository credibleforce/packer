#!/bin/bash
# rm -f vmlist; for vm in $(vmrun list | grep -Ev "^Total"); do echo $vm >> vmlist; done

if [ -z $1 ]; then
	echo "Missing snapshot name."
	echo "take_snap.sh <SNAP_NAME>"
	exit 1
fi

SNAP_NAME=$1
echo "Taking snap shot $SNAP_NAME"
for vm in $(cat vmlist.txt); do vmrun stop "$vm"; done
for vm in $(cat vmlist.txt); do vmrun -T ws snapshot "$vm" "$SNAP_NAME"; done
for vm in $(cat vmlist.txt); do vmrun start "$vm"; done
exit 0
