#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

ansible-playbook runshellDebug.yml --inventory-file=remote_hosts --extra-vars="hosts=alpha need_sudo=no" || exit 1
