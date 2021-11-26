#!/bin/bash
# Install tools
sudo apt update
sudo apt -y full-upgrade
sudo apt -y install rpi-update
sudo rpi-update -y
sudo apt -y install nano emacs libraspberrypi-dev autoconf automake libtool pkg-config alsa-base alsa-tools alsa-utils


# enable camera
# sudo raspi-config
sudo raspi-config nonint do_camera 0


# Clone repository
cd /opt
sudo mkdir fruitnanny
sudo chown pi:pi fruitnanny
git clone https://github.com/ivadim/fruitnanny


# Generate certificates
cd /opt/fruitnanny
openssl req -x509 -sha256 -nodes -days 2650 -newkey rsa:2048 -keyout configuration/ssl/fruitnanny.key -out configuration/ssl/fruitnanny.pem -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=root/CN=`hostname -f`"


# Install NodeJS
# curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# sudo apt -y install nodejs
# проверка
# node -v

# Install Node.js v14.x
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt -y install nodejs
cd /opt/fruitnanny/
npm install
npm run grunt


# Audio and Video pipeline setup
# sudo apt install -y gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad
# sudo apt install -y gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libgstreamer1.0-dev
# sudo apt install -y libgstreamer-plugins-base1.0-dev gstreamer1.0-alsa
# built from sources rpi camera module
cd ~
git clone https://github.com/thaytan/gst-rpicamsrc /tmp/gst-rpicamsrc
cd /tmp/gst-rpicamsrc
./autogen.sh --prefix=/usr --libdir=/usr/lib/arm-linux-gnueabihf/
make
sudo make install

# Docker installation
# git and extra libs
sudo apt -y install git curl libffi-dev python python-pip
# docker
cd ~
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
# docker-compose
sudo apt -y install docker-compose

# Janus WebRTC Gateway
# Install janus-gateway on Ubuntu using the Snap Store
# info https://github.com/RSATom/janus-gateway-snap
# chek run
# sudo systemctl status snap.janus-gateway.janus-gateway.service
sudo apt -y install snapd
sudo snap install janus-gateway
# chek
snap list janus-gateway


# Copy these files into Janus config directory:
# sudo mkdir janus
cp /opt/fruitnanny/configuration/janus/janus.jcfg /var/snap/janus-gateway/common/etc
cp /opt/fruitnanny/configuration/janus/janus.plugin.streaming.jcfg /var/snap/janus-gateway/common/etc
cp /opt/fruitnanny/configuration/janus/janus.transport.http.jcfg /var/snap/janus-gateway/common/etc


# Nginx
cd ~
sudo apt -y install nginx
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp /opt/fruitnanny/configuration/nginx/fruitnanny_http /etc/nginx/sites-available/fruitnanny_http
sudo cp /opt/fruitnanny/configuration/nginx/fruitnanny_https /etc/nginx/sites-available/fruitnanny_https
sudo ln -s /etc/nginx/sites-available/fruitnanny_http /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/fruitnanny_https /etc/nginx/sites-enabled/
# Password Nginx
# sudo sh -c "echo -n 'fr:' >> /etc/nginx/.htpasswd"
# sudo sh -c "openssl passwd -1 "123" -apr1 >> /etc/nginx/.htpasswd"


# Autostart Audio, Video, NodeJS and Janus
sudo cp /opt/fruitnanny/configuration/systemd/audio.service /etc/systemd/system/
sudo cp /opt/fruitnanny/configuration/systemd/video.service /etc/systemd/system/
# sudo cp /opt/fruitnanny/configuration/systemd/janus.service /etc/systemd/system/
sudo cp /opt/fruitnanny/configuration/systemd/fruitnanny.service /etc/systemd/system/
sudo systemctl enable audio
sudo systemctl start audio
sudo systemctl enable video
sudo systemctl start video
# sudo systemctl enable janus
# sudo systemctl start janus
sudo systemctl enable fruitnanny
sudo systemctl start fruitnanny


