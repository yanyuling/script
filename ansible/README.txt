ansible-playbook  demo.yml --inventory-file=remote_hosts --extra-vars="hosts=game_tencent1 need_sudo=no"

ansible-playbook  demo.yml --inventory-file=remote_hosts --extra-vars="hosts=game_tencent2 need_sudo=yes"
