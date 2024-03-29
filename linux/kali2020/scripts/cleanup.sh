#!/bin/bash -eux

# Uninstall Ansible and dependencies.
pip uninstall ansible
apt-get remove python-pip python-dev

# Apt cleanup.
apt autoremove
apt update

# Delete unneeded files.
rm -f /home/vagrant/*.sh

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

# Disable root account over SSH
sed -i '/PermitRootLogin yes/d' /etc/ssh/sshd_config