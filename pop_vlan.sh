#!/bin/bash
echo "popping vlan from controller $3 to node $1, vlan_id $2"
curl -u onos:rocks -X POST "172.17.0.$3:8181/onos/v1/flows/of:000000000000000$1" -H "content-type: application/json" -d '{
    "priority":40002,
    "timeout":0,
    "isPermanent": true,
    "deviceId": "of:000000000000000'$1'",
    "treatment": {
      "instructions": [
       	{
	"type": "L2MODIFICATION",
	"subtype": "VLAN_POP"
       	},
        {
        "type": "OUTPUT",
	"port": "CONTROLLER"
        }
      ]
    },
    "selector":{
      "criteria": [
	{
	"type": "VLAN_VID",
	"vlanId": "'$2'"
	}
      ]
    }
}'
