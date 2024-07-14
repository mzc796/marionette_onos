VMware Fusion
#Ubuntu VM Specification
Mem: 8GB
Storage: 20GB
CPU Architecture: AMD64
Image: ubuntu-22.04.4-desktop-amd64.iso
System: Ubuntu 22.04.4 LTS

#System preparation
sudo apt-get update
sudo apt-get install vim
sudo apt install docker.io
sudo apt install net-tools
sudo apt install curl

#Add $USER to the docker group
sudo usermod -aG docker $USER
#Activate the changes to group
newgrp docker
#Pull atomix docker
docker pull atomix/atomix:3.1.5
#Run three atomix dockers
docker run -t -d --name atomix-1 atomix/atomix:3.1.5
docker run -t -d --name atomix-2 atomix/atomix:3.1.5
docker run -t -d --name atomix-3 atomix/atomix:3.1.5 
#Inspect atomix docker
docker inspect atomix-1 | grep -i ipaddress
docker inspect atomix-2 | grep -i ipaddress
docker inspect atomix-3 | grep -i ipaddress
#IPAddress is empty

#Check out ONOS source code to get the tool
 to generate atomix configuration files
#Generate Atomix config files, path is under onos source code

git clone https://gerrit.onosproject.org/onos
cd onos
./tools/test/bin/atomix-gen-config 172.17.0.2 ~/atomix-1.conf 172.17.0.2 172.17.0.3 172.17.0.4
./tools/test/bin/atomix-gen-config 172.17.0.3 ~/atomix-2.conf 172.17.0.2 172.17.0.3 172.17.0.4
./tools/test/bin/atomix-gen-config 172.17.0.4 ~/atomix-3.conf 172.17.0.2 172.17.0.3 172.17.0.4

#Copy Atomix config files to docker images
docker cp ~/atomix-1.conf atomix-1:/opt/atomix/conf/atomix.conf
docker cp ~/atomix-2.conf atomix-2:/opt/atomix/conf/atomix.conf
docker cp ~/atomix-3.conf atomix-3:/opt/atomix/conf/atomix.conf

#Restart Atomix docker instances for configurtion to take effect
docker restart atomix-1
docker restart atomix-2
docker restart atomix-3

#Inspect the docker IPAddress configuration
docker inspect atomix-1 | grep -i ipaddress
docker inspect atomix-2 | grep -i ipaddress
docker inspect atomix-3 | grep -i ipaddress

#Login ONOS GUI
Run Firefox
access http://172.17.0.5:8181/onos/ui
Username: onos
Password: rocks

#Build Mininet on the VM
sudo apt-get install mininet
#Run mininet with customized topology and connect to onos-1 onos-2 but not onos-3

