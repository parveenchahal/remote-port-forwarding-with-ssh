fail() {
    echo "Execution failed. $1"
    exit 1
}

CONFIG_DIR='/etc/remote-port-forwarding-with-ssh'

[ -d $CONFIG_DIR ] || mkdir $CONFIG_DIR || fail 'Not able to create dir.'

[ -f "remote-port-forwarding-with-ssh.sh" ] || fail "remote-port-forwarding-with-ssh.sh file not found"

cp remote-port-forwarding-with-ssh.sh /usr/sbin/remote-port-forwarding-with-ssh
chmod +x "/usr/sbin/remote-port-forwarding-with-ssh"

touch "$CONFIG_DIR/remote-port-mapping.conf"
touch "$CONFIG_DIR/remote.conf"

tee /etc/systemd/system/remote-port-forwarding-with-ssh.service << EOF
[Unit]
Description=Remote port forwarding using ssh
[Install]
WantedBy=multi-user.target
[Service]
Type=simple
WorkingDirectory=/usr/sbin
ExecStart=/bin/bash remote-port-forwarding-with-ssh "$CONFIG_DIR/remote-port-mapping.conf" "$CONFIG_DIR/remote.conf"
StandardOutput=file:/var/log/remote-port-forwarding-with-ssh.log
StandardError=file:/var/log/remote-port-forwarding-with-ssh-err.log
SyslogIdentifier=%n
EOF
