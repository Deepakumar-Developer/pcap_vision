import paramiko

def get_path(hostname, username, password):

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
    client.connect(hostname=hostname, username=username, password=password, timeout=60, look_for_keys=False, allow_agent=False, banner_timeout=200, auth_timeout=60)

    for drive in ['D', 'C']: # ['C', 'D', 'E', 'F', 'G']:  # Adjust this list based on your system    
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