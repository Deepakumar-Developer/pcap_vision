import paramiko

def get_interfance(hostname, username, password, tshark_path):
    # Run the command to list interfaces
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
    client.connect(hostname=hostname, username=username, password=password, timeout=60, look_for_keys=False, allow_agent=False, banner_timeout=200, auth_timeout=60)
    print('SSH connection established to ' + hostname)
    stdin, stdout, stderr = client.exec_command(f'"{tshark_path.strip()}" -D')
    print('Command executed: ' + f'{tshark_path.strip()}" -D')
    
    output = stdout.read().decode('utf-8')

    if stderr.read() != b'':
        raise Exception("Error retrieving interface list: " + str(stderr.read()))
    
    interface = []
    
    # Parse the output to find the index of the desired interface
    for line in output.splitlines():
        interface.append([line.split('.')[0],line.split('(')[-1].replace(')', '')])  # Return the index part before the dot and the interface name
    client.close()

    return {'interface': interface}