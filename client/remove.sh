systemctl stop remote-port-forwarding-with-ssh.service
rm /usr/sbin/remote-port-forwarding-with-ssh
rm -r /etc/remote-port-forwarding-with-ssh
rm /var/log/remote-port-forwarding-with-ssh.log
rm /var/log/remote-port-forwarding-with-ssh-err.log
systemctl daemon-reload
