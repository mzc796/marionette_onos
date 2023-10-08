#!/bin/bash
echo "delete flow entry $((0x${2})) from controller $3 on node $1"
curl -u onos:rocks -X DELETE "172.17.0.$3:8181/onos/v1/flows/of:000000000000000$1/$((0x${2}))"
