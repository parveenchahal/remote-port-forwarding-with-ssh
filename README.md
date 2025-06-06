# Proxy setup
1. Create a VM or Container instance in cloud with minimal linux based distro. e.g.: Debian or Ubuntu.
   Create with smallest capacity/resource to reduce the cost.
1. Add client's public key of SSH key pair in authorized_keys or while creating VM.
1. Enable `net.ipv4.ip_forward`
   ```sh
   sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
   ```
   Restart sysctl service or machine.
   Command to restart sysctl
   ```sh
   sudo systemctl restart systemd-sysctl
   ```
   Enablement can be check with
   ```sh
   sysctl -p
   ```
1. Allow the the ports requried to serve the traffic. e.g.: 80, 443 or 22.
1. SSH remote forwarding might not be allow to directly listen on port less than 1024. It requires root access.
1. Client can listen on different port and then setup port forwarding on proxy machine.
   Commands to do port forwarding
   ```sh
   sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080 # In client we can map 8080:localhost:80
   sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 4443 # # In client we can map 4443:localhost:443
   ```

# Client Setup
1. Clone this repo
   ```sh
   git clone https://github.com/parveenchahal/remote-port-forwarding-with-ssh.git
   ```
1. ```sh
   cd remote-port-forwarding-with-ssh/client
   ```
1. ```sh
   chmod +x ./setup.sh
   ```
1. Install
   ```
   sudo ./setup.sh --user $USER
   ```
1. Configure `/etc/remote-port-forwarding-with-ssh/remote-port-mapping.conf`
   Open file
   ```
   sudo vim /etc/remote-port-forwarding-with-ssh/remote-port-mapping.conf 
   ```
   Add port mapping
   ```
   8080=localhost:80
   4443=localhost:443
   ```
1. Configure `/etc/remote-port-forwarding-with-ssh/remote.conf`
   Open file
   ```
   sudo vim /etc/remote-port-forwarding-with-ssh/remote.conf
   ```
   Add proxy details for ssh
   ```
   user=ubuntu
   address=<proxy vm IP/Domain>
   port=22
   ssh_key=/home/<your user>/.ssh/id_rsa
   ```
1. SSH manually for first time so that remote host can be added in known_hosts file.
   ```
   ssh <user>@<IP/Domain>
   ```
1. Enable service in systemctl
   ```
   sudo systemctl enable remote-port-forwarding-with-ssh.service
   ```
1. Start service
   ```
   sudo systemctl start remote-port-forwarding-with-ssh.service
   ```
1. With any change in conf file service requires restart.
   ```
   sudo systemctl restart remote-port-forwarding-with-ssh.service
   ```
