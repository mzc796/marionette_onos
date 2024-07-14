#!/bin/bash
#pull onos docker
docker pull onosproject/onos:2.2.2

for i in {1..3}
do
   echo "Creating and Running onos-$i"
   docker run -t -d --name onos-$i onosproject/onos:2.2.2
   echo "Checking onos-$i ip address"
   IP=$(sudo docker inspect onos-$i | grep IPAddress | cut -d '"' -f 4 | head -2)
   echo "Generate onos-$i configuration files using docker ip $IP"
   cd ~/onos
   ./tools/test/bin/onos-gen-config $IP ~/cluster-$i.json -n 172.17.0.2 172.17.0.3 172.17.0.4
   echo "Create configuration directory for onos-$i"
   docker exec onos-$i mkdir /root/onos/config
   echo "Copy ONOS cluster config files to docker images"
   docker cp ~/cluster-$i.json onos-$i:/root/onos/config/cluster.json
   echo "Restart onos-$i instances"
   docker restart onos-$i
done

<<'END_COMMENT'
#Run ONOS docker
docker run -t -d  --name onos-1 onosproject/onos:2.2.2
docker run -t -d  --name onos-2 onosproject/onos:2.2.2
docker run -t -d  --name onos-3 onosproject/onos:2.2.2

#Check onos docker ip addresses
docker inspect onos-1 | grep -i ipaddress
docker inspect onos-2 | grep -i ipaddress
docker inspect onos-3 | grep -i ipaddress

#Generate ONOS cluster configuration files using docker ip obtained above
./tools/test/bin/onos-gen-config 172.17.0.5 ~/cluster-1.json -n 172.17.0.2 172.17.0.3 172.17.0.4
./tools/test/bin/onos-gen-config 172.17.0.6 ~/cluster-2.json -n 172.17.0.2 172.17.0.3 172.17.0.4
./tools/test/bin/onos-gen-config 172.17.0.7 ~/cluster-3.json -n 172.17.0.2 172.17.0.3 172.17.0.4

#Create configuration directory for ONOS docker images
docker exec onos-1 mkdir /root/onos/config
docker exec onos-2 mkdir /root/onos/config
docker exec onos-3 mkdir /root/onos/config

#Copy ONOS cluster config files to docker images
docker cp ~/cluster-1.json onos-1:/root/onos/config/cluster.json
docker cp ~/cluster-2.json onos-2:/root/onos/config/cluster.json
docker cp ~/cluster-3.json onos-3:/root/onos/config/cluster.json

#Restart ONOS instances
docker restart onos-1
docker restart onos-2
docker restart onos-3
END_COMMENT
