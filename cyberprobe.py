# CyberProbe
# This script provides tools for managing and monitoring a Linux system.

import os
import subprocess

def update_packages():
    subprocess.run(['sudo', 'apt-get', 'update'])
    subprocess.run(['sudo', 'apt-get', 'upgrade', '-y'])

def update_kernel():
    subprocess.run(['sudo', 'apt-get', 'update'])
    subprocess.run(['sudo', 'apt-get', 'dist-upgrade', '-y'])

def add_user():
    username = input("Enter the username to add: ")
    subprocess.run(['sudo', 'adduser', username])

def delete_user():
    username = input("Enter the username to delete: ")
    subprocess.run(['sudo', 'deluser', username])

def check_os_version():
    subprocess.run(['lsb_release', '-a'])

def check_network_connectivity():
    subprocess.run(['ping', '-c', '4', 'google.com'])

def change_ip_address():
    ip_address = input("Enter the new IP address: ")
    interface = input("Enter the network interface (e.g., eth0): ")
    subprocess.run(['sudo', 'ifconfig', interface, ip_address])

def arp_commands():
    print("1. Display ARP table")
    print("2. Add ARP entry")
    print("3. Delete ARP entry")
    arp_option = input("Choose an option: ")
    if arp_option == '1':
        subprocess.run(['arp', '-a'])
    elif arp_option == '2':
        ip_address = input("Enter the IP address: ")
        mac_address = input("Enter the MAC address: ")
        subprocess.run(['sudo', 'arp', '-s', ip_address, mac_address])
    elif arp_option == '3':
        ip_address = input("Enter the IP address: ")
        subprocess.run(['sudo', 'arp', '-d', ip_address])
    else:
        print("Invalid option")

def main():
    while True:
        print("1. Update packages")
        print("2. Update Linux kernel")
        print("3. Add user")
        print("4. Delete user")
        print("5. Check current operating system version")
        print("6. Check network connectivity")
        print("7. Change IP address")
        print("8. ARP commands")
        print("9. Exit")
        option = input("Choose an option: ")
        if option == '1':
            update_packages()
        elif option == '2':
            update_kernel()
        elif option == '3':
            add_user()
        elif option == '4':
            delete_user()
        elif option == '5':
            check_os_version()
        elif option == '6':
            check_network_connectivity()
        elif option == '7':
            change_ip_address()
        elif option == '8':
            arp_commands()
        elif option == '9':
            break
        else:
            print("Invalid option")

if __name__ == "__main__":
    main()
