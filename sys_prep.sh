#!/bin/bash
#System preparation
sudo apt-get update
sudo apt-get install vim mininet
sudo apt install curl net-tools docker.io

#Add $USER to the docker group
sudo usermod -aG docker $1
#Activate the changes to group
newgrp docker

