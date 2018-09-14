#!/bin/bash

# Obtain the absolute path of the script files
SCRIPT_PATH="$(realpath "$0")"
MISC_INC_PATH="$(realpath "misc.inc.sh")"

# Include the miscellaneous lib
. $MISC_INC_PATH


# Setup the mirrorlist
MIRRORLIST=/etc/pacman.d/mirrorlist
MIRRORTEMP=/tmp/mirrorlist

echo_cyan "[ARCH-INIT] Rewriting /etc/pacman.d/mirrorlist..."

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

echo_cyan "[ARCH-INIT] Installing fundamental packages..."
yes | pacman -Syu
yes | pacman -S vim openssh

echo_cyan "[ARCH-INIT] Configuring sshd..."

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

echo_cyan "[ARCH-INIT] Setting the root password..."

while :
do
    passwd
    if [ $? = 0 ]; then
        break
    fi
    echo_red "Failed to renew the password. Retrying..."
done

echo_cyan "[ARCH-INIT] Setting up the systemd services..."

systemctl enable sshd
systemctl start sshd

echo_yellow "Now Leaving the Container..."

# Cleanup the script file
rm $SCRIPT_PATH
rm $MISC_INC_PATH

kill $PPID
