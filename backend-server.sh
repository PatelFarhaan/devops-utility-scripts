#! /bin/bash

backend_project_path="/home/ubuntu/webapp" &&

sudo apt-get update && sudo apt-get upgrade -y &&

sudo apt-get install python3-pip -y &&

sudo pip3 install virtualenv &&

sudo apt-get install supervisor -y &&

sudo apt update &&

sudo apt install nginx -y &&

cd $backend_project_path && sudo chmod +x start.sh &&

virtualenv venv &&

source venv/bin/activate &&

pip3 install -r  requirements.txt &&

sudo pip3 install gunicorn &&

sudo cp "$backend_project_path/supervisor_processsor/backend.conf" /etc/supervisor/conf.d &&

sudo systemctl restart supervisor
