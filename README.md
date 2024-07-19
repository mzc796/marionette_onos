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
   cd marionette_onos-master/
   sudo chmod 774 sys_prep.sh build_atomix_dockers.sh build_onos_dockers.sh mn_run.py restart_onos_cluster.sh
   ```
3. Prepare the system.
   
   ```sudo ./sys_prep.sh```
4. Add and activate $USER to the docker group. $USER is the recent user of your Ubuntu system
   ```
   sudo usermod -aG docker $USER
   newgrp docker
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

    Open another teriminal
    ```
    cd marionette_onos_master/
    sudo ./mn_run.sh
    ```
    
    Wait for seconds and go back to refresh the browsers for each of the three controllers, you should be able to see a 5-node topology. 
16. Trigger Host Discovery
    on Mininet terminal:
    
    ```mininet>h1 ping h2```
    
    On the UI, click Menu->Network->Hosts, we will find h1 and h2.
18. Host Discovery on UIs
    
    On Topology GUI, hit the button 'H', and the hosts will show up. For details, see https://pica8-fs.atlassian.net/wiki/spaces/PicOS433sp/pages/4063290/ovs-ofctl+add-flow+bridge+flow.
    NOTE: Now we can see the shortest path from h1 to h2 is ```h1->sw1->sw4->sw5->h2``` as shown on the Topology GUI.
20. Check Flow Entries and Shortest Path Routing
    
    On the UI, click Menu->Network->Devices. Choose of:0000000000000001 (sw1). On the top right, click `show flow view for selected device`, we can see that sw1 has been configured two flow entries by ```Application: fwd```      to forward the packets of h1 ping h2. Similarly, we will find that sw4 and sw5 are also configured with flow entries to support h1 ping h2. ```sw1->sw4->sw5``` is the shortest path as we can see from the topology.
21. Stop h1 ping h3 with ```Control+C``` on the Mininet terminal to prepare for the next step demo.

## Marionette Attack
1. Open another terminal to initiate the attack on ONOS-3
   ```
   cd marionette_onos-master
   ./topo_poison.sh 7
   ```
   NOTE: 7 is the last digit of onos-3's IP address which means we want to attack from onos-3

### Result
1. The dynamic topology can be noticed on the ONOS UIs.
2. Refresh the Web UIs to clear cached expired links. The topology seems the same as before since the degree sequence is maintained. But now, sw1 connects to sw2 and sw3 is between s1 and sw4, showing the success of the Marionette attack.
3. Now we can see the shortest path from h1 to h2 is ```h1->sw1->sw2->sw5->h2``` as shown on the Topology GUI.
4. On Mininet terminal, ```mininet> h1 ping h2```. On ONOS UIs, we will find that sw1, sw2, and sw5 have flow entries configured by ```Application: fwd```, which means the legitimate ONOS-1, ONOS-2 discover


## Controller Impersonating Attack (Optional)
We also found that both the ONOS and OpenDaylight cluster implementations are insecure. If one of the controller peers is down, a malicious controller with an incomplete cluster configuration can join the cluster. This experiment strengthens the motivation of the Marionette work and validates the assumption of a malicious controller in the cluster. 

In the case of this ONOS cluster:

On the docker terminal:

1. We shut down ONOS-3:
   ```docker stop onos-3```

   Go back to the UIs, the onos-3 disappears.
2. Build onos-mal and check its IP Address
   ```
   docker run -t -d --name onos-mal onosproject/onos:2.2.2
   docker inspect onos-mal | grep -i ipaddress
   ```

   It should have the same IP Address as onos-3. If not, configure it to it (172.17.0.7).
3. Configure the cluster file for onos-mal
   
   Create a configuration directory for ONOS docker images
   ```
   docker exec onos-mal mkdir /root/onos/config
   ```

   Replicate cluster-3.json to cluster-mal.json and edit it by removing below (or any two of the three `atomix`s)
   ```
   ,
   {
      "id": "atomix-2",
      "ip": "172.17.0.2",
      "port": 5679
    },
    {
      "id": "atomix-3",
      "ip": "172.17.0.3",
      "port": 5679
    }
   ```

   Configure cluster-mal.json to the onos-mal

   ```
   docker cp ~/cluster-mal.json onos-mal:/root/onos/config/cluster.json
   ```
4. Restart the onos-mal

   ```
   docker restart onos-mal
   ```

   Refresh the UIs and we will see onos-mal join the cluster successfully.
