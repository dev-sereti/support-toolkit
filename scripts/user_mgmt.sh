#!/bin/bash

# User Management Script

ACTION=$1
USERNAME=$2
LOCK=$3
UNLOCK=$4
RESET_PW=$5
case $ACTION in
    "list")
        if [[ $3 == "--active" ]]; then
            echo "Active users:"
            who | awk '{print $1}' | sort | uniq
        elif [[ $3 == "--inactive" ]]; then
            echo "Inactive users (30+ days):"
            lastlog -b 30 | awk 'NR>1 && $0 !~ /Never logged in/ {print $1}'
        else
            echo "All users:"
            cut -d: -f1 /etc/passwd | sort
            echo -e "\nLogged in users:"
            who | awk '{print $1}' | sort | uniq
        fi
        ;;
    "modify")
        if [[ -z $USERNAME ]]; then
            echo "Error: Username not specified"
            exit 1
        fi
        
        if [[ $LOCK == "--lock" ]]; then
            passwd -l $USERNAME
            usermod --expiredate 1 $USERNAME
            echo "User $USERNAME locked and expired"
        elif [[ $UNLOCK == "--unlock" ]]; then
            passwd -u $USERNAME
            usermod --expiredate "" $USERNAME
            echo "User $USERNAME unlocked"
        elif [[ $RESET_PW == "--reset-password" ]]; then
            passwd $USERNAME
        else
            echo "No modification option specified"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 list [--active|--inactive]"
        echo "       $0 modify <username> [--lock|--unlock|--reset-password]"
        exit 1
        ;;
esac


exit 0