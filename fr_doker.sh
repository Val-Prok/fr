#!/bin/bash

# updates
sudo apt update
sudo apt full-upgrade
sudo apt install rpi-update
sudo rpi-update -y

# enable camera
# sudo raspi-config
sudo raspi-config nonint do_camera 0

# Install tools
# git and extra libs
sudo apt -y install git curl libffi-dev python python-pip
# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
# docker-compose
sudo apt -y install  docker-compose

# Clone repository
cd /opt
sudo mkdir fruitnanny
sudo chown pi:pi fruitnanny
git clone https://github.com/ivadim/fruitnanny

# Generate certificates
cd /opt/fruitnanny
openssl req -x509 -sha256 -nodes -days 2650 -newkey rsa:2048 -keyout configuration/ssl/fruitnanny.key -out configuration/ssl/fruitnanny.pem -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=root/CN=`hostname -f`"

# Generate apache passwords
sudo sh -c "echo -n 'fr:' >> /etc/nginx/.htpasswd"
sudo sh -c "openssl passwd -1 "123" -apr1 >> /etc/nginx/.htpasswd"

# Reboot system
sudo shutdown -r -t sec 30

# Run the system with notifications
# cd /opt/fruitnanny
# docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d
