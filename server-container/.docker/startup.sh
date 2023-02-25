[ -d ~/.ssh ] || mkdir ~/.ssh
keys=$(echo "$AUTHORIZED_KEYS" | tr ";" "\n")
for key in $keys
do
  echo $key | base64 -d >> ~/.ssh/authorized_keys
done
service ssh start
sleep 315360000