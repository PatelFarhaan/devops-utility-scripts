#!/bin/bash


sudo apt-get update && sudo apt-get upgrade -y &&

sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y &&

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&

sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y &&

sudo apt update && apt list -a docker-ce &&

sudo docker pull jenkinsci/blueocean &&

sudo docker run \
  -d \
  -u root \
  -p 8081:8080 \
  --name jenkins \
  --restart always \
  -v `pwd`/data/jenkins:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean &&

while [ ! `sudo ls /home/ubuntu/data/jenkins/secrets/initialAdminPassword` ];
do
    sleep 15
done

sudo cat /home/ubuntu/data/jenkins/secrets/initialAdminPassword
