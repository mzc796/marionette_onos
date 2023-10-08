#!/bin/bash
echo "pushing vlan from controller $5 to node $1, inport $2, vlan_id $3, output $4"
curl -u onos:rocks -X POST "172.17.0.$5:8181/onos/v1/flows/of:000000000000000$1" -H "content-type: application/json" -d '{
    "priority":40001,
    "timeout":0,
    "isPermanent": true,
    "deviceId": "of:000000000000000'$1'",
    "treatment": {
      "instructions": [
      	{
	"type":"L2MODIFICATION",
	"subtype":"VLAN_PUSH"
	},
      	{
	"type":"L2MODIFICATION",
	"subtype":"VLAN_ID",
	"vlanId":'$3'
	},
        {
        "type": "OUTPUT",
	"port": "'$4'"
        }
      ]
    },
    "selector":{
      "criteria": [
        {
        "type": "ETH_SRC",
	"mac": "02:eb:13:f3:41:8a"
        },
	{
	"type": "IN_PORT",
	"port": "'$2'"
	}
      ]
    }

}'
