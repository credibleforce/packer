#!/bin/bash

vagrant destroy -f && vagrant up && ssh vagrant@172.21.0.30 "git clone --branch develop https://github.com/mobia-security-services/splunk-lab && git clone --branch develop https://github.com/mobia-security-services/splunk-engagement-ansible && cd splunk-lab/ansible && ansible-playbook -vvvv -i inventory/lab.yml playbooks/build-env.yml"