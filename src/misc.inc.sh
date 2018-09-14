#This file is for including. DO NOT EXECUTE DIRECTLY


# echo_colored
# Usage: echo_colored COLOR_CODE [OPTIONS] TEXT ...

echo_colored () {
    COLOR=$1
    OPT=$2

    if [[ $2 == "-"* ]];
    then
        shift 2
        echo -e $OPT "\e[${COLOR}m$*\e[m"
    else
        shift 1
        echo -e "\e[${COLOR}m$*\e[m"
    fi
}

echo_green () {
    echo_colored 32 $*
}

echo_red () {
    echo_colored 31 $*
}

echo_cyan () {
    echo_colored 36 $*
}

echo_yellow () {
    echo_colored 33 $*
}

echo_pink () {
    echo_colored 35 $*
}

# check_if_success
# Usage: check_if_success [COMMAND NAME]
# ** This function checks the $? and show the error message if it is non-zero.

check_if_success () {
    if [ ! $? = 0 ]; then
        echo_red -n "An Unexpected Error has occurred while executing "
        echo_yellow -n "\"$1\""
        echo_red "."
        exit $?
    fi
}

# Trap for SIGINT
trap 'echo_red "\nAborted by the key signal." && exit 255' 2
