# make_arch.sh
# Create a Archlinux container and Start it

# Include the miscellaneous lib
. misc.inc.sh

# Constants
ARCH_INIT_SH=./arch_init.sh
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

echo_green "The Container was successfully launched!"
echo_green -n "Now the "
echo_yellow -n "initialization script "
echo_green "is being executed."

# Drop into the root shell
sleep 3
lxc exec $CONTAINER_NAME /bin/bash /root/$ARCH_INIT_SH_NAME
