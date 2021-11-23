#!/bin/bash

# updates
sudo apt update
sudo apt full-upgrade -y
sudo apt install rpi-update -y
sudo rpi-update

# enable camera
# sudo raspi-config
sudo raspi-config nonint do_camera 0

# Install tools
# git and extra libs
# sudo apt -y install git curl libffi-dev python python-pip
sudo apt -y install git curl libffi-dev

# ERROR install python
sudo apt -y install python-is-python2
# ERROR install python-pip
# ERROR Package 'python-pip' has no installation candidate
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
sudo python get-pip.py


# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
# docker-compose
sudo apt -y install  docker-compose

# Reboot system
sudo shutdown -r -t sec 30
