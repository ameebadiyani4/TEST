#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
sudo apt-get update
sudo apt-get install virtualbox-5.0 ansible
pip install --upgrade ansible
wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
sudo dpkg -i vagrant_2.0.2_x86_64.deb
vagrant --version
virtualbox --version
ansible --version

vagrant up
vagrant ssh-config | grep "IdentityFile" | cut -c16-100 >> key
VAR=`cat key`

echo "[defaults]" >> playbook/ansible.cfg
echo "inventory = hosts" >> playbook/ansible.cfg
echo "remote_user = vagrant" >> playbook/ansible.cfg
echo "private_key_file = $VAR" >> playbook/ansible.cfg
echo "host_key_checking = False" >> playbook/ansible.cfg

rm -rf key

vagrant ssh -c 'sudo apt-get install python unzip'

cd playbook
ansible-playbook -v -b -c paramiko playbook.yml
