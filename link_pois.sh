#!/bin/bash
curl -u onos:rocks -X POST "127.0.0.1:8181/onos/v1/flows/of:0000000000000002" -H "content-type: application/json" -d '{
    "priority":40001,
    "timeout":0,
    "isPermanent": true,
    "deviceId": "of:0000000000000002",
    "treatment": {
      "instructions": [
        {
        "type": "OUTPUT",
	"port": "4"
        }
      ]
    },
    "selector":{
      "criteria": [
        {
        "type": "ETH_SRC",
	"mac": "02:eb:fc:da:48:09"
        }
      ]
    }

}'