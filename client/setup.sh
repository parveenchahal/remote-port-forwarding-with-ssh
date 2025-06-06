fail() {
    echo "Execution failed. $1"
    exit 1
}

PARSED_OPTIONS=$(getopt -o "" -l "user:" -- "$@")
eval set -- "$PARSED_OPTIONS"

user="$USER"

while true; do
  case "$1" in
    --user)
      user="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unexpected option: $1" >&2
      exit 1
      ;;
  esac
done

CONFIG_DIR='/etc/remote-port-forwarding-with-ssh'

[ -d $CONFIG_DIR ] || mkdir $CONFIG_DIR || fail 'Not able to create dir.'

[ -f "remote-port-forwarding-with-ssh.sh" ] || fail "remote-port-forwarding-with-ssh.sh file not found"

cp remote-port-forwarding-with-ssh.sh /usr/bin/remote-port-forwarding-with-ssh
sudo chmod 755 /usr/bin/remote-port-forwarding-with-ssh 

touch "$CONFIG_DIR/remote-port-mapping.conf"
touch "$CONFIG_DIR/remote.conf"

tee /etc/systemd/system/remote-port-forwarding-with-ssh.service << EOF
[Unit]
Description=Remote port forwarding using ssh
[Install]
WantedBy=multi-user.target
[Service]
Type=simple
User=$user
WorkingDirectory=/usr/sbin
ExecStart=/bin/bash remote-port-forwarding-with-ssh "$CONFIG_DIR/remote-port-mapping.conf" "$CONFIG_DIR/remote.conf"
StandardOutput=file:/var/log/remote-port-forwarding-with-ssh.log
StandardError=file:/var/log/remote-port-forwarding-with-ssh-err.log
SyslogIdentifier=%n
EOF
