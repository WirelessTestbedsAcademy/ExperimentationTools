TWIST Router Ansible support project
====================================

Provides custom Ansible configuration that can directly be used for code deployment on TWIST testbed devices.

## Usage

- Install Ansible

        pip install -r requirements.txt

- Check the connection to ALL routers (will fail if device is not provisioned)

        ansible routers -m ping

- Deploy dependencies for simple experiment
    
        ansible-playbook example.yml

- Access the nodes

        ssh -F ssh.cfg tplink20

Note that all Ansible commands must be executed from this directory as it is source for the configuration file (`ansible.cfg`). For details refer to Ansible documentation.
