#!/bin/bash
# CyberProbe
# A simple pentesting tool for "Educational" purposes.
# This is a bash script for Linux users

# Function to perform nmap scan
perform_nmap_scan() {
    local target=$1
    local scan_type=$2
    local output_file="${target}_${scan_type}_scan_results.txt"

    echo "Starting $scan_type scan on $target..."

    case "$scan_type" in
        1)
            nmap -sS "$target" -oN "$output_file"
            ;;
        2)
            nmap -sT "$target" -oN "$output_file"
            ;;
        3)
            nmap -sU "$target" -oN "$output_file"
            ;;
        4)
            nmap -sS -sU -O -A "$target" -oN "$output_file"
            ;;
        5)
            nmap -Pn "$target" -oN "$output_file"
            ;;
        6)
            nmap -O "$target" -oN "$output_file"
            ;;
        7)
            nmap -sV "$target" -oN "$output_file"
            ;;
        8)
            nmap -A "$target" -oN "$output_file"
            ;;
        9)
            nmap -sV -O "$target" -oN "$output_file"
            ;;
        *)
            echo "Invalid scan type. Please choose a number between 1 and 9."
            return
            ;;
    esac

    echo "Scan completed."
    echo "Results saved to $output_file"
}

# Function to perform dirb scan
perform_dirb_scan() {
    local target=$1
    local wordlist=$2
    local output_file="${target}_dirb_scan_results.txt"
    
    echo "Starting directory scan on $target using wordlist $wordlist..."
    
    dirb "$target" "$wordlist" -o "$output_file"

    echo "Scan completed."
    echo "Results saved to $output_file"
}

# Function to perform hashcat cracking
perform_hashcat_crack() {
    local hash_file=$1
    local hash_type=$2
    local wordlist=$3
    local output_file="${hash_file}_crack_results.txt"

    echo "Starting hashcat crack on $hash_file with hash type $hash_type..."

    hashcat -m "$hash_type" "$hash_file" "$wordlist" -o "$output_file"

    echo "Crack completed."
    echo "Results saved to $output_file"
}

# Main script
echo "Choose the tool to use:"
echo "1) nmap"
echo "2) dirb"
echo "3) hashcat"
read -p "Enter the number of your choice: " tool_choice

if [ "$tool_choice" = "1" ]; then
    read -p "Enter the target IP address or hostname: " target
    echo "Choose the scan type:"
    echo "1) SYN"
    echo "2) TCP"
    echo "3) UDP"
    echo "4) Comprehensive"
    echo "5) Pawn"
    echo "6) OS Detection"
    echo "7) Service Version Detection"
    echo "8) Aggressive"
    echo "9) Service Version and OS Detection"
    read -p "Enter the number of the scan type: " scan_type
    perform_nmap_scan "$target" "$scan_type"
elif [ "$tool_choice" = "2" ]; then
    read -p "Enter the target website URL: " target
    read -p "Enter the wordlist file path: " wordlist
    perform_dirb_scan "$target" "$wordlist"
elif [ "$tool_choice" = "3" ]; then
    read -p "Enter the path to the hash file: " hash_file
    echo "Choose the hash type:"
    echo "0) MD5"
    echo "100) SHA1"
    echo "1400) SHA256"
    echo "1700) SHA512"
    echo "1800) bcrypt"
    echo "3200) bcrypt $2$"
    echo "500) MD5 Crypt"
    echo "1500) descrypt"
    echo "7400) sha256crypt"
    echo "7500) sha512crypt"
    read -p "Enter the number of the hash type: " hash_type
    read -p "Enter the wordlist file path: " wordlist
    perform_hashcat_crack "$hash_file" "$hash_type" "$wordlist"
else
    echo "Invalid choice. Please choose '1' for nmap, '2' for dirb, or '3' for hashcat."
fi