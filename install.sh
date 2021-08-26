#!/bin/bash

# installation file to get blog up and running on home server

# install basic dependencies

echo "INSTALLING DOCKER"
apt-get update
apt-get install -y sudo
apt-get remove -y docker docker-engine docker.io
apt-get install -y apt-transport-https
apt-get install -y ca-certificates
apt-get install -y curl
apt-get install -y software-properties-common
apt-get install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
# make
apt-get -y install build-essential
apt-get -y install make
# install ruby stuff for jekyll
apt-get -y install ruby-dev
apt-get -y install libz-dev
apt-get -y install ruby-bundler
# install jeykll
gem update --system
gem install bundle nokogiri jekyll

# add nonroot user
sudo adduser site
sudo usermode -aG docker,sudo site

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# export site domain
export DOMAIN="beren.io"
# copy nginx config to correct place
sudo mkdir -p ~/docker-data/nginx/conf.d/site.conf
cp nginx_site.conf ~/docker-data/nginx/conf.d/site.conf
# ensure all volumes are created
mkdir -p ~/docker-data/nginx/conf.d/:/etc/nginx/conf.d:ro
mkdir -p ~/docker-data/nginx/logs:/var/log/nginx
mkdir -p ~/docker-data/nginx/ssl:/ssl:ro
mkdir -p ~/docker-data/nginx/site:/site:ro
mkdir -p ~/docker-data/certbot/conf:/etc/letsencrypt
mkdir -p ~/docker-data/certbot/www:/var/www/certbot

mkdir -p ~/docker-data/certbot/conf:/etc/letsencrypt
mkdir -p ~/docker-data/certbot/www:/var/www/certbot

# start containers
docker-compose up -d
# request ssl certificate
#docker exec -it certbot certbot certonly --renew-by-default

# restart containers
docker-compose down
docker-compose up -d

# pull down the github repo (requires you to enter your credentials)
git clone https://github.com/BerenMillidge/BerenMillidge.github.io
# install dependencies
cd BerenMillidge.github.io
bundle install --path vendor/bundle

# then update to run
cd
cd blog_deployment
bash update_site.sh
