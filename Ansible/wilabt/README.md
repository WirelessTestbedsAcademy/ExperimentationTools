Example scripts for using Ansible on w-iLab.t (1 or 2)
======================================================

## Usage

- Install Ansible

        sudo bash install_ansible.sh

- Install the WiSHFUL framework using an Ansible playbook

        ansible-playbook -i inventory install_wishful.yml

    This command will run on all nodes defined in the inventory file.

- When using the example RSpec, be sure to replace YOUR PROJ NAME by your actual project name used to activate your jFed experiment (and don't forget to modify the IDs of the nodes you have reserved)
