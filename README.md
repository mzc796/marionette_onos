# Security Issue Explanation: 
This artifact should be safe to implement in a cloud environment even if the environment has real SDN controllers. That is because (1) the virtual network (Mininet) and the controllers (ONOS and OpenDaylight) are either on a virtual machine or a docker. (2) We have specified the IP addresses of our testbed controllers in the scripts such that the Marionette will not connect with a real-world controller to attack any real-world network.

# Introduction:
Marionette is a new topology poisoning technique that manipulates OpenFlow link discovery packet forwarding to alter topology information. Our technique introduces a globalized topology poisoning attack that leverages control privileges. Marionette implements a reinforcement learning algorithm to compute a poisoned topology target and injects flow entries to achieve a long-lived stealthy attack. We use the open-source SDN controller ONOS cluster and OpenDaylight to demonstrate our attack. There are two parts of this artifact. In Part 1, we have a simple topology to demonstrate the proof-of-concept functionality (i.e. precise link manipulation and misleading routing). In Part 2, we provide a complete attack starting with computing a deceptive topology with Reinforcement Learning and then implementing the poisonous flow entries to make the learned deceptive topology happen based on an enterprise fat tree topology. In details:

## Part 1: Proof-of-Concept Demonstration
Marionette attacks ONOS cluster from a malicious ONOS to manipulate links on a 5-node topology with Mininet to demonstrate its capability of precise link manipulation while maintaining the same degree sequence. We will also demonstrate the difference in the routings by ONOS reactive forwarding before and after the attack. 

## Part 2: Marionette Attack on Fat-Tree Topology
Marionette attacks OpenDaylight from a malicious application to attract more flows to an eavesdropping point. Step 1: The Marionette collects nodes and topology information to learn a deceptive topology based on an enterprise fat-tree topology to meet the attack goal. Step 2: The Marionette composes corresponding poisonous flow entries to mislead the OpenDaylight controller to learn a deceptive topology as we designed in Step 1.  

# Part 1 Demonstration: Marionette on ONOS Cluster
## Virtual Machine Platform
VMware Fusion
## Ubuntu VM Specification
Mem: 8GB
Storage: 20GB
CPU Architecture: AMD64
Image: ubuntu-22.04.4-desktop-amd64.iso
System: Ubuntu 22.04.4 LTS

## Steps to Build a ONOS cluster with Mininet:
1. Download the marionette_onos.zip
2. Extract it to the home folder and change privilege 
'''cd marionette_onos
sudo chmod 774 sys_prepare build_atomix_dockers.sh build_onos_dockers.sh mn_run.py restart_onos_cluster.sh
'''
3. Prepare the system, $USER_NAME is the recent user of your ubuntu system 
'''sudo ./sys_prepare $USER_NAME '''
4. Install and run atomix dockers
'''./build_atomix_dockers.sh '''
5. Install and run onos dockers
'''./build_onos_dockers.sh '''
6. Login the ONOS UI
click Firefox, access http://172.17.0.5:8181/onos/ui, http://172.17.0.6:8181/onos/ui, http://172.17.0.7:8181/onos/ui
    user: onos
    password: rocks

7. After the onos UI loaded, there should be three ONOS listed on each of the UIs as they build a cluster.
8. On the http://172.17.0.5:8181/onos/ui, click the menu on top left, go to Application, search openflow, choose OpenFlow Provider Suite, click the triangle on the top right to activate this application, confirm-> Okay.
9. Still on the Application list, search fwd, choose Reactive Forwarding, click the triangle on top right to activate this application, confirm-> Okay.

10. Run Mininet to connect with ONOS-1 and ONOS-2 but not ONOS-3
'''sudo ./mn_run.sh '''
Wait for a second and go back to refresh the browsers each of the three controller, you should be able to see a 5-node topology. 
11. Trigger Host Discovery
on mininet termial
''' h1 ping h2 '''
12. Host Discovery on UIs
    on UIs, hit the button 'H', the hosts will show up. For details, see https://pica8-fs.atlassian.net/wiki/spaces/PicOS433sp/pages/4063290/ovs-ofctl+add-flow+bridge+flow.
13. Correct Shortest Path Routing
Please notice that the shortest path between h1 and h2 is sw1->sw4->sw5

## Marionette attack
1. Initiate the attack on ONOS-3
Open another terimal
'''cd marionette_onos'''
./topo_poison.sh 7 
NOTE: 7 is the last digit of onos-3's ip address which means we want to attack from onos-3

2. See the attack consequence
Wait for a second and refresh the UIs. 
The topology changes will be captured and the shortest path from h1 to h2 is sw1->sw2->sw5 now.

# Part 2 Demonstration: Marionette as an Application on OpenDaylight

