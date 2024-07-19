# Part 1: Marionette on ONOS Cluster with Motivating Example Topology
Marionette attacks the ONOS cluster from a malicious ONOS to manipulate links in Figure 1 motivating example topology with Mininet to demonstrate its capability of precise link manipulation while maintaining the same degree sequence. We also show the difference in the routings by ONOS reactive forwarding before and after the attack.
## Virtual Machine Platform
VMware Fusion
## Virtual Machine Summary
Memory: 8GB

Storage: 20GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: ubuntu-22.04.4-desktop-amd64.iso

NOTE: After installation and reboot, please don't select `Install Now` when the window of `Software Updater` pops up. Otherwise, it may cause an error of 'not enough space' later.
## Build and Run an ONOS Cluster with Mininet:
1. Download the marionette_onos-master.zip
2. Extract it to the home folder and change the privilege
   ```
   cd marionette_onos-master
   sudo chmod 774 sys_prep.sh build_atomix_dockers.sh build_onos_dockers.sh mn_run.py restart_onos_cluster.sh
   ```
3. Prepare the system.
   
   ```sudo ./sys_prep.sh```
4. Add $USER to the docker group, $USER is the recent user of your Ubuntu system
   ```
   sudo usermod -aG docker $USER
   Activate the changes to group
   newgrp docker
   ```
5. Switch to $USER_NAME and back to marionette_onos-master folder
   ```
   su - $USER_NAME
   cd marionette_onos-master\
   ```
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
11. After the ONOS UI is loaded, there should be three ONOS listed on each of the UIs as they build a cluster.
12. On http://172.17.0.5:8181/onos/ui, click the menu on the top left, go to Application, search openflow, choose OpenFlow Provider Suite, click the triangle on the top right to activate this application, confirm-> Okay.
13. Still on the Application list, search fwd, choose Reactive Forwarding, click the triangle on the top right to activate this application, confirm-> Okay.

14. Run Mininet to connect with ONOS-1 and ONOS-2 but not ONOS-3.
    
    ```sudo ./mn_run.sh```
    
    Wait for seconds and go back to refresh the browsers for each of the three controllers, you should be able to see a 5-node topology. 
16. Trigger Host Discovery
    on Mininet terminal:
    
    ```mininet>h1 ping h2```
18. Host Discovery on UIs
    on UIs, hit the button 'H', and the hosts will show up. For details, see https://pica8-fs.atlassian.net/wiki/spaces/PicOS433sp/pages/4063290/ovs-ofctl+add-flow+bridge+flow.
19. Correct Shortest Path Routing
Please notice that the shortest path between h1 and h2 is sw1->sw4->sw5

## Marionette Attack
1. Open another terminal to initiate the attack on ONOS-3
   ```
   cd marionette_onos-master
   ./topo_poison.sh 7
   ```
   NOTE: 7 is the last digit of onos-3's IP address which means we want to attack from onos-3

### Result
Wait for a second and refresh the UIs. 
The topology changes will be captured and the shortest path from h1 to h2 is sw1->sw2->sw5 now.



