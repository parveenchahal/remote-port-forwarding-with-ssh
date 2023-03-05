function __print_message() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $1"
}

CONFIG_DIR='/etc/remote-port-forwarding-with-ssh'
MAX_WAIT=600
port_mapping_conf=$1
remote_conf=$2
IFS=$'\n'
args=''
for line in `cat $port_mapping_conf`; do
  line=$(echo $line | tr -d " \t\n\r")
  if [[ "$line" != *"="* ]]
  then
    continue
  fi
  key="$( cut -d '=' -f 1 <<< "$line" )";
  value="$( cut -d '=' -f 2 <<< "$line" )";
  if [[ (! -z $key) && (! -z $value) ]]
  then
    args="$args -R $key:$value"
  fi
done
source $remote_conf

if [ -z $user ]
then
  __print_message "user is not provided in $CONFIG_DIR/remote.conf"
  exit 1
fi
if [ -z $address ]
then
  __print_message "address is not provided in $CONFIG_DIR/remote.conf"
  exit 1
fi
if [ -z $port ]
then
  __print_message "port is not provided in $CONFIG_DIR/remote.conf"
  exit 1
fi

if [ -z $ssh_key ]
then
  __print_message "ssh_key is not provided in $CONFIG_DIR/remote.conf"
  exit 1
fi

if [ -z $args ]
then
  __print_message "No valid remote port mapping found in $CONFIG_DIR/remote-port-mapping.conf"
  exit 1
fi

wait_time=60
while :
do
  start_time=$(date +%s)
  cmd="ssh -N -o ConnectTimeout=10 $args $user@$address -p $port -i $ssh_key"
  __print_message "Executing command: $cmd"
  eval $cmd
  now=$(date +%s)
  diff=$((now - start_time))
  if [ $diff -gt 600 ]
  then
    wait_time=60
  fi
  __print_message "Will try again after $wait_time seconds"
  sleep $wait_time
  wait_time=$((wait_time * 2))
  if [ $wait_time -gt $MAX_WAIT ]
  then
    wait_time=$MAX_WAIT
  fi
done
