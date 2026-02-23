#!/bin/bash


# PORTS
# Mongo: 27017
# Jenkins: 8081
# Grafana: 3000
# Cadvisor: 8100
# Prometheus: 9090
# Node Exporter: 9100
# Nginx Exporter: 9113


# Grafana Dashboards
# 13112 -> Container Monitoring
# 193 -> Containers Overview
# 12646 -> Jenkins
# 11074 -> Server Health
# 12767 -> Nginx 


# Variables
data_folder="/home/ubuntu/data"
mongo_dir="$data_folder/mongo"
jenkins_dir="$data_folder/jenkins"
plugin_dir="$jenkins_dir/plugins"
grafana_dir="$data_folder/grafana"
prometheus_dir="$data_folder/prometheus"
mongo_username=""
grafana_username=""
jenkins_username=""
grafana_password=""
mongo_password=""
jenkins_password=""

list_of_plugins_to_download=(
  "prometheus"
)


create_prometheus_file (){
   mkdir $prometheus_dir
   echo "
global:
   scrape_interval: 60s
   evaluation_interval: 60s

alerting:
   alertmanagers:
      - static_configs:
         - targets:

rule_files:

scrape_configs:
   -  job_name: 'Jenkins'
      metrics_path: '/prometheus/'
      scheme: http
      tls_config:
               insecure_skip_verify: true
      basic_auth:
               username: $jenkins_username
               password: $jenkins_password
      static_configs:
               - targets: ['localhost:8081']

   -  job_name: 'node-exporter'
      metrics_path: '/metrics'
      scheme: http
      static_configs:
               - targets: ['localhost:9090', 'localhost:9100', 'localhost:8100', 'localhost:9113']
   " > "$prometheus_dir/prometheus.yml"
}

create_data_directory (){
   mkdir $data_folder
}

install_docker (){
   sudo apt-get update && sudo apt-get upgrade -y &&
   sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y &&
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
   sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io -y &&
   sudo apt update && apt list -a docker-ce
}

install_grafana (){
   mkdir "$grafana_dir" &&
   sudo chown -R 472:472 $grafana_dir
   sudo docker run \
      -d \
      -it \
      --network host \
      --name=grafana \
      --restart always \
      -v "$grafana_dir:/var/lib/grafana" \
      -e "GF_SECURITY_ADMIN_USER=$grafana_username" \
      -e "GF_SECURITY_ADMIN_PASSWORD=$grafana_password" \
      grafana/grafana
}

install_prometheus (){
   sudo docker run \
      -d \
      -it \
      --network host \
      --restart always \
      --name prometheus \
      -v "$prometheus_dir/prometheus.yml":/etc/prometheus/prometheus.yml \
      prom/prometheus
}

install_node_exporter (){
   sudo docker run \
      -d \
      -it \
      --pid="host" \
      -p 9100:9100 \
      --restart always \
      --name node_exporter \
      quay.io/prometheus/node-exporter:latest
}

install_cadvisor (){
   sudo docker run \
      --detach=true \
      --name=cadvisor \
      --restart always \
      --publish=8100:8080 \
      --volume=/:/rootfs:ro \
      --volume=/sys:/sys:ro \
      --volume=/var/run:/var/run:ro \
      --volume=/dev/disk/:/dev/disk:ro \
      --volume=/var/lib/docker/:/var/lib/docker:ro \
      gcr.io/google-containers/cadvisor:latest
}

install_jenkins (){
   sudo docker run \
      -d \
      -it \
      --user root \
      -p 8081:8080 \
      -p 50000:50000 \
      --name jenkins \
      --restart always \
      -v "$jenkins_dir":/var/jenkins_home \
      jenkins/jenkins
}

install_nginx_and_exporter (){
   sudo apt-get install nginx -y &&

   sudo docker run \
      -d \
      -it \
      --network host \
      --restart always \
      --name nginx_exporter \
      nginx/nginx-prometheus-exporter \
      -nginx.scrape-uri http://localhost:80/metrics
}

download_plugin() {
  if [[ -f $(sudo ls "$plugin_dir/$1.hpi") ]] || [[ -f $(sudo ls "$plugin_dir/$1.jpi") ]]; then
    echo "Skipped: $1 (already installed)"
    return 0
  else
    echo "Installing: $1"
    sudo wget -P "$plugin_dir" "https://updates.jenkins-ci.org/download/plugins/$1/latest/$1.hpi"
    return 0
  fi
}

install_jenkins_plugins (){
   while [ ! "$(sudo ls "$jenkins_dir/secrets/initialAdminPassword")" ];
   do
      sleep 20
   done

   for plugin in "${list_of_plugins_to_download[@]}"
   do
   download_plugin "$plugin"
   done
   
   sudo docker restart jenkins
   echo "######################################################"
   echo "JENKINS UNLOCK KEY"
   sudo cat "$jenkins_dir/secrets/initialAdminPassword"
   echo "######################################################"

   sudo docker restart jenkins
}

create_nginx_conf_file (){
   sudo sh -c '
   echo "server {
      listen       80;
      server_name  localhost;

      location / {
         root   /usr/share/nginx/html;
         index  index.html index.htm;
      }

      location /metrics {
        stub_status;
      }
   }
   " > "/etc/nginx/conf.d/default.conf" 
   '
   sudo systemctl restart nginx.service
}

install_mongo (){
   sudo docker run \
      -d \
      -it \
      -u root \
      --name mongo \
      -p 27017:27017 \
      --restart always \
      -v "$mongo_dir/mongo":/data/db \
      -e MONGO_INITDB_ROOT_USERNAME=$mongo_username \
      -e MONGO_INITDB_ROOT_PASSWORD=$mongo_password \
      mongo
}

create_data_directory
install_nginx_and_exporter
create_nginx_conf_file
install_docker
install_grafana
install_jenkins
install_jenkins_plugins
install_mongo
install_node_exporter
create_prometheus_file
install_prometheus
install_cadvisor
