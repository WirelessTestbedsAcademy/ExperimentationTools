Example scripts for using Ansible on w-iLab.t (1 or 2)
======================================================

## Usage

- Install Ansible

        sudo bash install_ansible.sh

- Install the WiSHFUL framework using an Ansible playbook

        ansible-playbook -i inventory install_wishful.yml

    This command will run on all nodes defined in the inventory file.
