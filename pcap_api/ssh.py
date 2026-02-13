# import paramiko
# import time

# # Connection details
# hostname = "172.25.149.227"
# username = "Deepakumar M"
# password = "48630."

# def get_interfance_index():
#     # Run the command to list interfaces
#     client = paramiko.SSHClient()
#     client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
#     client.connect(hostname, username=username, password=password)

#     tshark_path = r'D:\applications\softwareFamily\wiresharkFamily\Wireshark\tshark.exe'
#     stdin, stdout, stderr = client.exec_command(f'"{tshark_path}" -D')
#     output = stdout.read().decode()

#     if stderr.read() != b'':
#         raise Exception("Error retrieving interface list: " + str(stderr.read()))
    
#     interface = []
    
#     # Parse the output to find the index of the desired interface
#     for line in output.splitlines():
#         interface.append([line.split('.')[0],line.split('(')[-1].replace(')', '')])  # Return the index part before the dot and the interface name
#     client.close()

#     return {'interface': interface}
        
    

# # try:
# #     # 1. Initialize and connect
# #     client = paramiko.SSHClient()
# #     client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
# #     client.connect(hostname, username=username, password=password)

# #     # 2. Define the tshark command
# #     tshark_path = r'D:\applications\softwareFamily\wiresharkFamily\Wireshark\tshark.exe'
    
# #     # Define where to save the pcap on the REMOTE machine
# #     output_file = r'D:\DeepsProject\pcap\capture.pcap'

# #     # The command:
# #     # -i 4: interface index (you might need to change this)
# #     # -a duration:60: stop after 60 seconds
# #     # -w: write to file
# #     command = f'"{tshark_path}" -i 4 -a duration:60 -w "{output_file}"'

# #     # 3. Execute with a PTY to handle sudo password prompt if needed
# #     stdin, stdout, stderr = client.exec_command(command, get_pty=True)

# #     # 4. Provide the password if sudo asks for it
# #     stdin.write(password + '\n')
# #     stdin.flush()

# #     # 5. Read and print the output
# #     # Note: read().decode() will wait until the command finishes or times out
# #     print("Capturing packets...")
# #     output = stdout.read().decode()
# #     print(output)

# #     client.close()

# # except Exception as e:
# #     print(f"An error occurred: {e}")