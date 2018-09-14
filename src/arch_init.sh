#!/bin/bash

# Obtain the absolute path of this script
SCRIPT_PATH="$(realpath "$0")"

echo -e "\e[36m[ARCH-INIT] Installing fundamental packages...\e[m"

yes | pacman -Syu
yes | pacman -S vim openssh

echo -e "\e[36m[ARCH-INIT] Configuring sshd...\e[m"

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

echo -e "\e[36m[ARCH-INIT] Setting the root password...\e[m"

while :
do
    passwd
    if [ $? = 0 ]; then
        break
    fi
    echo -e "\e[31mFailed to renew the password. Retrying...\e[m"
done

echo -e "\e[36m[ARCH-INIT] Setting up the systemd services...\e[m"

systemctl enable sshd
systemctl start sshd

echo -e "\e[33mNow Leaving the Container...\e[m"

# Cleanup the script file
rm $SCRIPT_PATH

kill $PPID
