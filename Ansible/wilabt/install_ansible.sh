#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "{ \"failed\": true, \"msg\": \"This script should be run using sudo or as the root user\" }"
    exit 1
fi

#install dependencies
apt-get update
apt-get install python-dev libffi-dev python-pip -y

#install ansible
pip install --upgrade markupsafe setuptools ansible==2.0.2.0

touch /tmp/ansible-install-finished
