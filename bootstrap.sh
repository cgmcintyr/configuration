#!/bin/bash

set -eu  # abort on errors/undefined variables

NORMAL="\e[00m"; BOLD="\e[1;39m"

# make sure it's possible to `ssh localhost` using machine's own ssh key
if [ ! -e "$HOME/.ssh/id_rsa" ]; then
    mkdir -p "$HOME/.ssh"
    echo -e "${BOLD}This account doesn't have an ssh key - creating new one."
    echo -e "This key will not be password-protected, so it's advised"
    echo -e "to use it only to connect to localhost.${NORMAL}"
    sleep 2
    ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
    echo -e "${BOLD}Adding id_rsa to authorized keys...${NORMAL}"
    sleep 2
    cat "$HOME/.ssh/id_rsa.pub" >> ~/.ssh/authorized_keys
fi

sleep 2

# Ansible from official repos is ancient - use PPA
if command apt > /dev/null 2>&1; then
    echo -e "${BOLD}Installing Ansible and OpenSSH using apt...${NORMAL}"
    sudo apt-get update && sudo apt-get install --yes ansible openssh-server 
elif command dnf > /dev/null 2>&1; then
    echo -e "${BOLD}Installing Ansible and OpenSSH using dnf...${NORMAL}"
    CHECK_UPDATE=$(sudo dnf check-update > /dev/null 2>&1; echo $?)
    if [ $CHECK_UPDATE -eq 100 ] || [ $CHECK_UPDATE -eq 0 ]; then
        sudo dnf install -y ansible openssh-server 
    else
        echo -e "${BOLD}Error:${NORMAL} dnf check-update returned $CHECK_UPDATE"
    fi
else
    echo -e "${BOLD}Error:${NORMAL} unknown package manager"
    exit 1
fi
