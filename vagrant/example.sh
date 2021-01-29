#!/bin/bash

vagrant destroy -f && vagrant up && scp ../ansible/inventory/lab.yml vagrant@172.21.0.30:~ && scp ../../terraform-lab-build/templates/ansible_awx_docker.sh vagrant@172.21.0.30:~ && ssh vagrant@172.21.0.30 -C "chmod 755 ~/ansible_awx_docker.sh && ~/ansible_awx_docker.sh && cd /opt/repo/splunk-lab/ansible && ansible-playbook -i ~/lab.yml playbooks/build-env.yml"
