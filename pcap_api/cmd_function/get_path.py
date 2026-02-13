import paramiko

def get_path(hostname, username, password):

    # Run the command to list interfaces
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
    client.connect(hostname, username=username, password=password)

    for drive in ['C', 'D', 'E', 'F', 'G']:  # Adjust this list based on your system    
        cmd = f"dir /s /b {drive}:\\tshark.exe"
        stdin, stdout, stderr = client.exec_command(cmd)
        output = stdout.read().decode()
        if output and "File Not Found" not in output:
            client.close()
            return {"path": output}  # Return the found path

    if stderr.read() != b'':
        raise Exception("Error retrieving interface list: " + str(stderr.read()))
    client.close()
    return {'path': "File Not Found"}