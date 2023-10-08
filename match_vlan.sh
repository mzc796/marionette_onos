#!/bin/bash
echo "matching vlan from controller $4 to node $1, vlan_id $2, output $3"
curl -u onos:rocks -X POST "172.17.0.$4:8181/onos/v1/flows/of:000000000000000$1" -H "content-type: application/json" -d '{
    "priority":40001,
    "timeout":0,
    "isPermanent": true,
    "deviceId": "of:000000000000000'$1'",
    "treatment": {
      "instructions": [
        {
        "type": "OUTPUT",
	"port": "'$3'"
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
