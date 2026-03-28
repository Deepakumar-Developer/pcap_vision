import paramiko
import time

def get_pcap(hostname, username, password, tshark_path, index):

    
    # Run the command to list interfaces
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # Automatically add unknown host keys
    client.connect(hostname=hostname, username=username, password=password, timeout=60, look_for_keys=False, allow_agent=False, banner_timeout=200, auth_timeout=60)

    output_file = r'C:\Users\Deepakumar M\Desktop\capture.pcap'
    command = f'"{tshark_path.strip()}" -i {index} -a duration:15 -w "{output_file}"'

    # 3. Execute with a PTY to handle sudo password prompt if needed
    stdin, stdout, stderr = client.exec_command(command, get_pty=True)

    response = stdout.read().decode()

    if stderr.read() != b'':
        raise Exception("Error in Capture Pcap: " + str(stderr.read()))
    
    client.close()

    return {'output_file': output_file, 'response': response}
