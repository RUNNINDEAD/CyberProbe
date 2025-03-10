#!/bin/bash
# CyberProbe - A simple Linux administration tool 
function update_packages() {
    sudo apt-get update && sudo apt-get upgrade -y
}

function update_kernel() {
    sudo apt-get update && sudo apt-get dist-upgrade -y
}

function add_user() {
    read -p "Enter the username to add: " username
    sudo adduser $username
}

function delete_user() {
    read -p "Enter the username to delete: " username
    sudo deluser $username
}

function check_os_version() {
    lsb_release -a
}

function check_network_connectivity() {
    ping -c 4 google.com
}

function change_ip_address() {
    read -p "Enter the new IP address: " ip_address
    read -p "Enter the network interface (e.g., eth0): " interface
    sudo ifconfig $interface $ip_address
}

function arp_commands() {
    echo "1. Display ARP table"
    echo "2. Add ARP entry"
    echo "3. Delete ARP entry"
    read -p "Choose an option: " arp_option
    case $arp_option in
        1)
            arp -a
            ;;
        2)
            read -p "Enter the IP address: " ip_address
            read -p "Enter the MAC address: " mac_address
            sudo arp -s $ip_address $mac_address
            ;;
        3)
            read -p "Enter the IP address: " ip_address
            sudo arp -d $ip_address
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

while true; do
    echo "1. Update packages"
    echo "2. Update Linux kernel"
    echo "3. Add user"
    echo "4. Delete user"
    echo "5. Check current operating system version"
    echo "6. Check network connectivity"
    echo "7. Change IP address"
    echo "8. ARP commands"
    echo "9. Exit"
    read -p "Choose an option: " option
    case $option in
        1)
            update_packages
            ;;
        2)
            update_kernel
            ;;
        3)
            add_user
            ;;
        4)
            delete_user
            ;;
        5)
            check_os_version
            ;;
        6)
            check_network_connectivity
            ;;
        7)
            change_ip_address
            ;;
        8)
            arp_commands
            ;;
        9)
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
