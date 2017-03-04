#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMAND="ansible"

if ! type "$COMMAND" > /dev/null; then
  sudo apt-get update
  sudo apt-get install -y ansible
fi

echo "copying hosts file from $DIR/files/ansible/hosts to /etc/ansible/hosts"
sudo cp $DIR/files/ansible/hosts /etc/ansible/hosts

echo "setup complete"
