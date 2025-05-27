import paramiko

hostname = input("SSH IP: ")
port = 22
username = 'REDACTED'
ssh_key = 'REDACTED'


try:
    print("Connecting to server...", hostname)
    ssh_server = paramiko.SSHClient()
    ssh_server.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    ssh_server.connect(hostname, port, username, ssh_key)

    if ssh_server:
        print("CONNECTED!")

except Exception as error:
    print("ERROR CONNECTING", error)

stdin, stdout, stderr = ssh_server.exec_command('sudo rm /etc/netplan/50-cloud-init.yaml', get_pty=True)
print(stderr.read().decode())
print(stdout.read().decode())

cloudinit_disable = '''echo 'network: {config: disabled}' | sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg > /dev/null'''


modify_netplan = '''sudo tee /etc/netplan/50-cloud-init.yaml > /dev/null <<EOF
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - IP
      gateway4: IP
      nameservers:
        addresses:
          - IP
EOF
'''

stdin, stdout, stderr = ssh_server.exec_command(cloudinit_disable, get_pty=True)
print(stderr.read().decode())
print(stdout.read().decode())

stdin, stdout, stderr = ssh_server.exec_command(modify_netplan, get_pty=True)
print(stderr.read().decode())
print(stdout.read().decode())

stdin, stdout, stderr = ssh_server.exec_command('sudo netplan apply', get_pty=True)
print(stderr.read().decode())
print(stdout.read().decode())






