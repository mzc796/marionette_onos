#!/bin/bash
sudo mn --controller remote,ip=172.17.0.5 --controller remote,ip=172.17.0.6 --custom cus_topo_marionette.py --topo mytopo --switch ovs,protocols=OpenFlow13
