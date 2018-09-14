# make_arch.sh
# Create an Archlinux container and Start it

# Include the miscellaneous lib
. src/misc.inc.sh

# Constants
ARCH_INIT_SH=./src/arch_init.sh
ARCH_INIT_SH_NAME=arch_init.sh

# Get the Container name
while :
do

    echo_cyan -n "Enter the Container name:"
    read CONTAINER_NAME

    if [ ${#CONTAINER_NAME} = 0 ]; then
        echo_red "Empty Container name is not acceptable."
    else
        break
    fi

done
    
# Launch the Container
echo_green "Launching the container..."
lxc launch images:archlinux/current "$CONTAINER_NAME"

check_if_success "lxc launch"

# Copy the arch_init.sh
lxc file push $ARCH_INIT_SH "$CONTAINER_NAME/root/$ARCH_INIT_SH_NAME"

check_if_success "lxc file push"

# Show the Instruction

echo_green -n "The Container "
echo_yellow -n "$CONTAINER_NAME "
echo_green "was successfully launched!"
echo_green "Now the initialization script is being executed."


# Wait for dhcpcd of the container
DHCPWAITSEC=5
echo_cyan "Waiting for dhcpcd...(${DHCPWAITSEC}sec)"
sleep $DHCPWAITSEC

# Drop into the root shell
lxc exec $CONTAINER_NAME /bin/bash /root/$ARCH_INIT_SH_NAME
