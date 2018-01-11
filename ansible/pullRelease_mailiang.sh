#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

ansible-playbook runshellRelease.yml --inventory-file=remote_hosts --extra-vars="hosts=mailiang need_sudo=yes" || exit 1

