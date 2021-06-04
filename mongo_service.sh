#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y &&

sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y &&

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&

sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y &&

sudo apt update && apt list -a docker-ce &&

sudo docker pull mongo &&

sudo docker run -d -it -e MONGO_INITDB_ROOT_USERNAME=***REMOVED*** -e MONGO_INITDB_ROOT_PASSWORD=***REMOVED*** -p 27017:27017 --restart always --name=mongo -v /home/ubuntu/data:/data/db mongo