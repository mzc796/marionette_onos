#!/bin/bash
#Pull atomix docker
docker pull atomix/atomix:3.1.5
#Run three atomix dockers
docker run -t -d --name atomix-1 atomix/atomix:3.1.5
docker run -t -d --name atomix-2 atomix/atomix:3.1.5
docker run -t -d --name atomix-3 atomix/atomix:3.1.5

#Generate Atomix config files
##path is under onos source code

git clone https://gerrit.onosproject.org/onos
cd onos

#Set relevant env var to docker IP of Atomix instances obtained above
export OC1=172.17.0.2
export OC2=172.17.0.3
export OC3=172.17.0.4
# generate the config file
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


#inspect atomix ipaddress
docker inspect atomix-1 | grep -i ipaddress
docker inspect atomix-2 | grep -i ipaddress
docker inspect atomix-3 | grep -i ipaddress
