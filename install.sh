#!/bin/bash

# installation file to get blog up and running on home server

# install basic dependencies
apt-get remove -y docker docker-engine docker.io
apt-get install -y —no-install-recommends \  
    apt-transport-https \  
    ca-certificates \  
    curl \  
    software-properties-common
curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) | apt-key add —
add-apt-repository "deb \[arch=amd64\] [https://download.docker.com/linux/ubuntu](https://download.docker.com/linux/ubuntu) $(lsb_release -cs) stable"
apt-get updateapt-get install -y docker-ceusermod -aG docker $(id -u -n)

# make
apt-get -y install build-essential
apt-get -y install make

# add nonroot user
adduser site
usermode -aG docker,sudo site

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# export site domain
export DOMAIN="beren.io"
# copy nginx config to correct place
cp nginx_site_conf ~/docker-data/nginx/conf.d/site.conf

# start containers
docker-compose up -d
# request ssl certificate
docker exec -it certbot certbot certonly --renew-by-default

# restart containers
docker-compose down
docker-compose up -d

# pull down the github repo (requires you to enter your credentials)
git clone https://github.com/BerenMillidge/BerenMillidge.github.io
