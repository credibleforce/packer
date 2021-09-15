#!/bin/bash

vagrant destroy -f
vagrant up
scp ../ansible/inventory/lab.yml vagrant@172.21.0.30:~
scp ../../terraform-lab-build/templates/ansible_base.sh vagrant@172.21.0.30:~ 
ssh vagrant@172.21.0.30 -C "mkdir -p ~/deployment/ansible/ && echo '$(yq -r '.ansible_vault_password' settings.yml)' > ~/deployment/ansible/.vault_passwd.txt"
ssh vagrant@172.21.0.30 -C "chmod 755 ~/ansible_base.sh"
ssh vagrant@172.21.0.30 -C "~/ansible_base.sh"
ssh vagrant@172.21.0.30 -C "cd /opt/repo/splunk-lab/ansible; ansible-playbook -i ~/deployment/ansible/inventory.yml -e @~/deployment/ansible/lab_settings.yml playbooks/build-env-cli.yml"
