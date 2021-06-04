#!/bin/bash


cd /home/ubuntu/infrasketch
dangling_images=`sudo docker images -qa -f dangling=true`
if [ -z "$dangling_images" ]
then
	echo "No Dangling images"
else
	sudo docker rmi -f $dangling_images
fi

sudo docker build -t infracode_frontend . --no-cache &&
sudo aa-remove-unknown &&


is_image_running=`sudo docker ps | grep infracode_frontend`
if [ -z "$is_image_running" ]
then
  echo "No running container found"
else
	sudo docker stop infracode_frontend
fi

sudo docker run --name infracode_frontend --rm -d -it -p 3000:80 infracode_frontend
