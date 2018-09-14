#!/bin/bash

# Obtain the absolute path of this script
SCRIPT_PATH="$(realpath "$0")"


# Setup the mirrorlist
MIRRORLIST=/etc/pacman.d/mirrorlist
MIRRORTEMP=/tmp/mirrorlist

echo -e "\e[36m[ARCH-INIT] Rewriting /etc/pacman.d/mirrorlist...\e[m"

# Copy the current mirrorlist into /tmp
cp $MIRRORLIST $MIRRORTEMP

# Firstly, search for "Japan" to get the mirror URL of Japan
JAPAN_LINES=$(grep -e "Japan" -n $MIRRORTEMP | sed -e 's/:.*//g')

# Now we get the line numbers of Japan mirror URL.
# Next, move the URL to the top of the list.
for line in $JAPAN_LINES;
do
    # Delete the original line
    sed -i ${line}d $MIRRORLIST
    sed -i ${line}d $MIRRORLIST

    # Copy the URL to the top of the list
    sed -i 6a"$(sed -n $((${line}+1))p $MIRRORTEMP)" $MIRRORLIST
    sed -i 6a"$(sed -n $((${line}))p $MIRRORTEMP)" $MIRRORLIST
done

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
