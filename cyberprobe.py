# CyberProbe
# A simple pentesting tool for "Educational" purposes.

import nmap
import argparse
import requests
import sys
import base64
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes

def perform_scan(target, scan_type):
    nm = nmap.PortScanner()
    print(f"Starting {scan_type} scan on {target}...")
    
    if scan_type == 'SYN':
        nm.scan(target, arguments='-sS')
    elif scan_type == 'UDP':
        nm.scan(target, arguments='-sU')
    elif scan_type == 'Comprehensive':
        nm.scan(target, arguments='-sS -sU -O -A')
    elif scan_type == 'Pawn':
        nm.scan(target, arguments='-Pn')
    elif scan_type == 'OS Detection':
        nm.scan(target, arguments='-O')
    elif scan_type == 'Service Version Detection':
        nm.scan(target, arguments='-sV')
    elif scan_type == 'Aggressive':
        nm.scan(target, arguments='-A')
    elif scan_type == "Operating System + Service Version Detection":
        nm.scan(target, arguments='-O -sV')
    elif scan_type == "Service Version Detection + Aggressive":
        nm.scan(target, arguments='-sV -A')
    else:
        print("Invalid scan type. Please choose 'SYN', 'UDP', 'Comprehensive', 'Pawn', 'OS Detection', 'Service Version Detection', or 'Aggressive'.")
        return

    results = []
    print(f"Scan results for {target}:")
    for host in nm.all_hosts():
        host_info = f"Host: {host} ({nm[host].hostname()})\nState: {nm[host].state()}"
        print(host_info)
        results.append(host_info)
        for proto in nm[host].all_protocols():
            proto_info = f"Protocol: {proto}"
            print(proto_info)
            results.append(proto_info)
            lport = nm[host][proto].keys()
            for port in lport:
                port_info = f"Port: {port}\tState: {nm[host][proto][port]['state']}"
                print(port_info)
                results.append(port_info)
    
    save_scan_results(target, scan_type, results)

def save_scan_results(target, scan_type, results):
    filename = f"{target}_{scan_type}_scan_results.txt"
    with open(filename, 'w') as file:
        for line in results:
            file.write(line + '\n')
    print(f"Scan results saved to {filename}")

def scan_directories(target, wordlist):
    results = []
    with open(wordlist, 'r') as file:
        directories = file.readlines()
    
    print(f"Starting directory scan on {target} using wordlist {wordlist}...")
    
    for directory in directories:
        directory = directory.strip()
        url = f"http://{target}/{directory}"
        try:
            response = requests.get(url)
            if response.status_code == 200:
                result = f"Found directory: {url}"
                print(result)
                results.append(result)
        except requests.exceptions.RequestException:
            pass
    
    save_scan_results(target, "directory", results)

def encode_base64(encoded_string):
    try:
        decoded_string = base64.b64decode(encoded_string)
        decoded_string = decoded_string.decode('utf-8')
        return decoded_string
    except Exception as e:
        print(f"Error decoding base64 string: {e}")

def decode_binary(binary_string):
    try:
        binary_values = binary_string.split()
        ascii_characters = [chr(int(bv, 2)) for bv in binary_values]
        decoded_string = ''.join(ascii_characters)
        return decoded_string
    except Exception as e:
        print(f"Error decoding binary string: {e}")

def decode_hex(hex_string):
    try:
        bytes_object = bytes.fromhex(hex_string)
        decoded_string = bytes_object.decode('utf-8')
        return decoded_string
    except Exception as e:
        print(f"Error decoding hex string: {e}")

def load_private_key(private_key_path):
    with open(private_key_path, "rb") as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=None,
        )
    return private_key

def decrypt_rsa(encrypted_message, private_key):
    decrypted_data = private_key.decrypt(
        encrypted_message,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return decrypted_data

def main():
    while True:
        print("Choose the tool to use:")
        print("1) Nmap")
        print("2) Dirb")
        print("3) Base64")
        print("4) Binary")
        print("5) Hex")
        print("6) Decrypt RSA")
        print("7) Exit")
        choice = input("Enter the number of your choice: ")

        if choice == "1":
            target = input("Enter the target IP address or hostname: ")
            scan_type = input("Enter the scan type: ")
            perform_scan(target, scan_type)
        elif choice == "2":
            target = input("Enter the target website URL: ")
            wordlist = input("Enter the wordlist file path: ")
            scan_directories(target, wordlist)
        elif choice == "3":
            encoded_string = input("Enter the encoded string: ")
            decoded_string = encode_base64(encoded_string)
            print(f"Decoded string: {decoded_string}")
        elif choice == "4":
            binary_string = input("Enter the binary string: ")
            decoded_string = decode_binary(binary_string)
            print(f"Decoded string: {decoded_string}")
        elif choice == "5":
            hex_string = input("Enter the hex string: ")
            decoded_string = decode_hex(hex_string)
            print(f"Decoded string: {decoded_string}")
        elif choice == "6":
            encrypted_message_hex = input("Enter the encrypted message (hex format): ")
            private_key_path = input("Enter the path to the private key file: ")
            private_key = load_private_key(private_key_path)
            encrypted_message = bytes.fromhex(encrypted_message_hex)
            decrypted_message = decrypt_rsa(encrypted_message, private_key)
            print(f"Decrypted message: {decrypted_message.decode('utf-8')}")
        elif choice == "7":
            print("Exiting...")
            sys.exit(0)
        else:
            print("Invalid choice. Please choose a number between 1 and 7.")

if __name__ == "__main__":
    main()