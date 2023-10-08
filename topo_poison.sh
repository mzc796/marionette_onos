#!/bin/bash

#push_vlan $1:node $2:inport $3:vid $4:output $5:controller_id
#match_vlan $1:node $2:vid $3:output $4:controller_id
#pop_vlan $1:node $2:vid $3:controller_id

#A2->1B
sudo ./push_vlan.sh 3 1 1 2 $1
sudo ./pop_vlan.sh 2 1 $1
#B1->2A
sudo ./push_vlan.sh 3 2 2 1 $1
sudo ./pop_vlan.sh 1 2 $1

#D1->1C
sudo ./push_vlan.sh 1 1 3 2 $1
sudo ./pop_vlan.sh 3 3 $1
#C1->1D
sudo ./push_vlan.sh 1 2 4 1 $1
sudo ./pop_vlan.sh 4 4 $1


#C2->1A
sudo ./push_vlan.sh 2 1 5 2 $1
sudo ./match_vlan.sh 5 5 2 $1
sudo ./match_vlan.sh 4 5 1 $1
sudo ./pop_vlan.sh 1 5 $1
#A1->2C
sudo ./push_vlan.sh 4 1 6 2 $1
sudo ./match_vlan.sh 5 6 1 $1
sudo ./match_vlan.sh 2 6 1 $1
sudo ./pop_vlan.sh 3 6 $1


