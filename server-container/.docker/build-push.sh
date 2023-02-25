tag=$1
if [ -z $tag ]
then
  tag="latest"
fi
docker build --no-cache . -t pchahal24/ubuntu-with-ssh-server:$tag
docker push pchahal24/ubuntu-with-ssh-server:$tag