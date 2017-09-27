#!/bin/bash
cd "$(dirname "$0")"
ansible-playbook ../playbooktest.yml -i ../inventory -vvv --vault-password-file /etc/ssl/private/ansible.txt
