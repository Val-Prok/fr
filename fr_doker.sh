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

# Reboot system
sudo shutdown -r -t sec 30
