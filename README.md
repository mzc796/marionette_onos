# Artifact on Zenodo
https://doi.org/10.5281/zenodo.12786197
# Video Demo
https://www.youtube.com/watch?v=lwAGYcCBOxc
# Part 1: Marionette on ONOS Cluster with Motivating Example Topology
Marionette attacks the ONOS cluster from a malicious ONOS to manipulate links in Figure 1 motivating example topology with Mininet to demonstrate its capability of precise link manipulation while maintaining the same degree sequence. We also show the difference in the routings by ONOS reactive forwarding before and after the attack.
## Virtual Machine Platform
VMware Fusion
## Virtual Machine Summary
Memory: 8GB

Storage: 20GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: ubuntu-22.04.4-desktop-amd64.iso

NOTE: After installation and rebooting the VM, please DO NOT select `Install Now` when the `Software Updater` window pops up. Otherwise, it may cause an error of 'not enough space' later.
## Software Dependencies
1. ONOS (v1.4 and after)
2. Mininet (any version supports OpenFlow v1.3)

## Build and Run an ONOS Cluster with Mininet:
1. Download the ```marionette_onos.zip``` and extract it to $HOME

   NOTE: If you download the code from GitHub and the name is ```marionette_onos-master.zip```, please change the folder name to ```marionette_onos``` after extracting it to $HOME.

2. Change the privilege
   ```
   cd marionette_onos/
   sudo chmod 774 sys_prep.sh build_atomix_dockers.sh build_onos_dockers.sh mn_run.sh restart_onos_cluster.sh
   ```
3. Prepare the system
   
   ```sudo ./sys_prep.sh```
4. Add and activate $USER to the docker group. $USER is the recent user of your Ubuntu system
   ```
   sudo usermod -aG docker $USER
   newgrp docker
   ```
5. Install and run atomix dockers. We give atomix-1, atomix-2, and atomix-3 IP Addresses 172.17.0.2, 172.17.0.3, and 172.17.0.4, respectively.
   
   ```./build_atomix_dockers.sh```
6. Install and run onos dockers. The onos-1, onos-2, onos-3 have IP Addresses 172.17.0.5, 172.17.0.6, and 172.17.0.7, respectively.
   
   ```./build_onos_dockers.sh```
7. Login the ONOS UI
    click Firefox, access http://172.17.0.5:8181/onos/ui, http://172.17.0.6:8181/onos/ui, http://172.17.0.7:8181/onos/ui
```
    user: onos
    password: rocks
```
8. After the ONOS UI is loaded, there should be three ONOS listed on each of the UIs as they build a cluster.
9. On http://172.17.0.5:8181/onos/ui, click the menu on the top left, go to Application, search openflow, choose OpenFlow Provider Suite, click the triangle on the top right to activate this application, confirm-> Okay.
10. Still on the Application list, search fwd, choose Reactive Forwarding, click the triangle on the top right to activate this application, confirm-> Okay.

11. Run Mininet to connect with ONOS-1 and ONOS-2 but not ONOS-3.

    Open another teriminal
    ```
    cd marionette_onos/
    sudo ./mn_run.sh
    ```
    
    Wait for seconds and go back to refresh the browsers for each of the three controllers, you should be able to see a 5-node topology. 
12. Trigger Host Discovery
    on Mininet terminal:
    
    ```mininet>h1 ping h2```
    
    On the UI, click Menu->Network->Hosts, we will find h1 and h2.
13. Host Discovery on UIs
    
    On Topology GUI, hit the 'H' key on the keyboard, and the hosts will show up. For details, see https://wiki.onosproject.org/display/ONOS/Basic+ONOS+Tutorial#:~:text=To%20toggle%20between%20showing%20and,which%20they%20are%20the%20master.
    
    NOTE: Now we can see the shortest path from h1 to h2 is ```h1->sw1->sw4->sw5->h2``` as shown on the Topology GUI.
14. Check Flow Entries and Shortest Path Routing
    
    On the UI, click Menu->Network->Devices. Choose ```of:0000000000000001``` (sw1). On the top right, click `show flow view for selected device`, we can see that sw1 has been configured two flow entries by ```Application: fwd```      to forward the packets of h1 ping h2. Similarly, we will find that sw4 and sw5 are also configured with flow entries to support h1 ping h2. ```sw1->sw4->sw5``` is the shortest path as we can see from the topology.
15. Stop h1 ping h2 with ```Control+C``` on the Mininet terminal to prepare for the next step demo.

## Marionette Attack
1. Open another terminal to initiate the attack on ONOS-3
   ```
   cd marionette_onos
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

   Wait for seconds and refresh the UIs. We will see onos-mal join the cluster successfully.
## Discussion
There are three vulnerabilities we explored in the Marionette work:
- Insecure controller implementation (Controller Impersonation Attack)
- Insecure cluster role management (Follower controller without direct connection with the network can still configure the network by altering the cluster datastore)
- Insecure topology discovery (Flow entries can alter topology discovery result)
