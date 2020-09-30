#!/bin/bash -eux

# # Install Ansible dependencies.
# apt -y update && apt-get -y upgrade
# apt -y install python-pip python-dev libssl-dev libffi-dev

# # Install Ansible. Upgrade order is important, otherwise different parts of the
# # install will fail.
# pip install --upgrade pip
# pip install --upgrade cffi
# pip install ansible
# pip install --upgrade setuptools
# pip install --upgrade cryptography


# Install Ansible repository.
apt -y update && apt-get -y upgrade
apt-get install software-properties-common
apt apt-add-repository ppa:ansible/ansible-2.9

# Install Ansible.
apt-get -y update
apt-get -y install ansible
ansible --version
