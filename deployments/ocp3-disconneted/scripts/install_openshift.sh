#!/bin/bash
yum -y install openshift-ansible screen bind-utils
sed -i "s/#host_key_checking/host_key_checking = True/" /etc/ansible/ansible.cfg
sed -i "s/#log_path/log_path/" /etc/ansible/ansible.cfg

cd /usr/share/ansible/openshift-ansible/
ansible-playbook -i /root/inventory /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml && ansible-playbook -i /root/inventory /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
