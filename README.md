# Part 1: Marionette on ONOS Cluster
## Virtual Machine Platform
VMware Fusion
## Virtual Machine Summary
Memory: 8GB

Storage: 20GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: ubuntu-22.04.4-desktop-amd64.iso

## Steps to Build a ONOS cluster with Mininet:
1. Download the marionette_onos.zip
2. Extract it to the home folder and change the privilege
   ```
   cd marionette_onos
   sudo chmod 774 sys_prepare build_atomix_dockers.sh build_onos_dockers.sh mn_run.py restart_onos_cluster.sh
   ```
4. Prepare the system, $USER_NAME is the recent user of your Ubuntu system
   ```sudo ./sys_prepare $USER_NAME```
6. Install and run atomix dockers. We give atomix-1, atomix-2, and atomix-3 IP Addresses 172.17.0.2, 172.17.0.3, and 172.17.0.4, respectively.
   ```./build_atomix_dockers.sh```
8. Install and run onos dockers. The onos-1, onos-2, onos-3 have IP Addresses 172.17.0.5, 172.17.0.6, and 172.17.0.7, respectively.
   ```./build_onos_dockers.sh```
10. Login the ONOS UI
click Firefox, access http://172.17.0.5:8181/onos/ui, http://172.17.0.6:8181/onos/ui, http://172.17.0.7:8181/onos/ui
```
    user: onos
    password: rocks
```
11. After the onos UI loaded, there should be three ONOS listed on each of the UIs as they build a cluster.
12. On the http://172.17.0.5:8181/onos/ui, click the menu on the top left, go to Application, search openflow, choose OpenFlow Provider Suite, click the triangle on the top right to activate this application, confirm-> Okay.
13. Still on the Application list, search fwd, choose Reactive Forwarding, click the triangle on top right to activate this application, confirm-> Okay.

14. Run Mininet to connect with ONOS-1 and ONOS-2 but not ONOS-3
    ```sudo ./mn_run.sh```
Wait for a second and go back to refresh the browsers each of the three controller, you should be able to see a 5-node topology. 
16. Trigger Host Discovery
    on mininet terminal
    ```mininet>h1 ping h2```
18. Host Discovery on UIs
    on UIs, hit the button 'H', the hosts will show up. For details, see https://pica8-fs.atlassian.net/wiki/spaces/PicOS433sp/pages/4063290/ovs-ofctl+add-flow+bridge+flow.
19. Correct Shortest Path Routing
Please notice that the shortest path between h1 and h2 is sw1->sw4->sw5

## Marionette attack
1. Initiate the attack on ONOS-3
   Open another terminal
   ```cd marionette_onos```
   ```./topo_poison.sh 7```
NOTE: 7 is the last digit of onos-3's ip address which means we want to attack from onos-3

3. See the attack consequence
Wait for a second and refresh the UIs. 
The topology changes will be captured and the shortest path from h1 to h2 is sw1->sw2->sw5 now.



