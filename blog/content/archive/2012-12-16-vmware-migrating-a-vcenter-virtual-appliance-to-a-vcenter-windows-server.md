---
title: 'VMware: Migrating a vCenter virtual appliance to a vCenter Windows server'
author: Zachary Loeber
type: post
date: 2012-12-17T04:30:52+00:00
url: /blog/2012/12/16/vmware-migrating-a-vcenter-virtual-appliance-to-a-vcenter-windows-server/
categories:
  - Networking
  - Powershell
  - Storage
  - System Administration
  - Virtualization
  - VMware

---
I finally bit the bullet and migrated my lab from a vCenter virtual appliance to a vCenter Windows server. This is what I did to maintain all my settings and not disrupt any currently running VMs.

<!--more-->

  1. Download [InventorySnapshot][1] to a workstation or your new VCenter server (as long as the vmware powerCLI and Java 1.5 is installed).
  2. Run the run.bat file to start InventorySnapshot
  3. Put in the IP or hostname of your old VMware appliance as well as the credentials and a good place to drop the resulting snapshot, select to “Take Snapshot”[<img class="aligncenter size-medium wp-image-704" alt="InvSnap" src="/wp-content/uploads/2012/12/InvSnap.jpg?resize=300%2C133" width="300" height="133" srcset="/wp-content/uploads/2012/12/InvSnap.jpg?resize=300%2C133 300w, wp-content/uploads/2012/12/InvSnap.jpg?w=683 683w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]
  4. A new window will come up with a few tabs that looks like this:[<img class="aligncenter size-medium wp-image-705" alt="InvSnap2" src="/wp-content/uploads/2012/12/InvSnap2.jpg?resize=300%2C46" width="300" height="46" srcset="/wp-content/uploads/2012/12/InvSnap2.jpg?resize=300%2C46 300w, wp-content/uploads/2012/12/InvSnap2.jpg?w=730 730w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]
  5. Don’t worry about the host passwords, just make sure everything is selected in the Inventory Tree tab and then select the Generate PowerCLI code in the last tab.
  6. Copy all the output from the folder you specified earlier to the new vCenter server.
  7. Open a VMware vSphere PowerCLI window and run the following to connect locally: 
    <pre>Set-ExecutionPolicy RemoteSigned</pre>
    
    <pre>Connect-VIServer localhost</pre>

  8. Open the createInventory.ps1 file then copy and paste everything above the line that states, “# ### START ADDHOSTS CLUSTER”
  9. At this point you have the basic cluster setup but not much else. I was unable to get the hosts to automatically add. To get around this I just manually added them (kinda stole them from the vCenter virtual appliance). So open up a vSphere client and connect to your new vCenter server, right0click on your cluster and select to add a host. Proceed to add all the hosts in your cluster. (Note: You will get warnings about duplicating configurations and causing issues with the old vCenter server, that is ok, just select Yes and move on as all host configuration for networking and storage will be maintained and no outage for currently running VMs will occur).
 10. By the time you have gotten to this point your old VMware appliance will show all hosts and VMs as disconnected and your new vCenter server will have all the goods.[<img class="aligncenter size-full wp-image-706" alt="InvSnap3" src="/wp-content/uploads/2012/12/InvSnap3.jpg?resize=270%2C279" width="270" height="279" data-recalc-dims="1" />][4]
 11. But what about everything else? Luckily enough, most networking and other host settings carry over so your VMs should have stayed live this entire time.  But if you had DRS or host affinities setup there is more you can do to automate the flip to your new server. Go back into that createInventory.ps1 file and comment out (with #) the first several lines of the script which creates the cluster and adds the hosts. It will look something like this when you are done (minus the rest of the script, just leave all that other stuff alone). 
    <pre># ### START RESTORE DC: Datacenter</pre>
    
    <pre># ### START CREATE DC: Datacenter</pre>
    
    <pre># Create DC: Datacenter in folder: null</pre>
    
    <pre>$parentFolder = Get-Folder -NoRecursion</pre>
    
    <pre><b>#New-Datacenter -Location $parentFolder -name "Datacenter"</b></pre>
    
    <pre># ### END CREATE DC: Datacenter</pre>
    
    <pre># ### START RESTORE CLUSTER: Cluster1</pre>
    
    <pre># ### START CREATE_CLUSTER_IN FOLDER: host</pre>
    
    <pre># ### START CREATE CLUSTER: Cluster1</pre>
    
    <pre># Create cluster: Cluster1 in datacenter Datacenter</pre>
    
    <pre># parent folder of cluster Cluster1 host</pre>
    
    <pre># Finding Parent Folder. Path: //Datacenter/host</pre>
    
    <pre>$si = Get-View -id "SearchIndex-SearchIndex"</pre>
    
    <pre>$parentChain = "//Datacenter/host"</pre>
    
    <pre>$parentFolderId = $si.FindByInventoryPath($parentChain)</pre>
    
    <pre>$parentFolder = Get-Folder -id $parentFolderId</pre>
    
    <pre><b>#New-Cluster -Location $parentFolder -Name "Cluster1"</b></pre>
    
    <pre># ### END CREATE CLUSTER: Cluster1</pre>
    
    <pre># ### END CREATE_CLUSTER_IN FOLDER: host</pre>
    
    <pre># ### START ADDHOSTS CLUSTER: Cluster1</pre>
    
    <pre>$cluster = Get-Cluster -location (get-datacenter -name "Datacenter") -name "Cluster1"</pre>
    
    <pre># Adding host 192.168.1.250 to cluster "Cluster1"</pre>
    
    <pre><b>#Add-VMHost 192.168.1.250 -Location $cluster -user root -password 'PASSWORD' -Force</b></pre>
    
    <pre># Adding host 192.168.1.251 to cluster "Cluster1"</pre>
    
    <pre><b>#Add-VMHost 192.168.1.251 -Location $cluster -user root -password 'PASSWORD' –Force</b></pre>

 12. Then save and run the script in the already open VMware PowerCLI window. You may get a few errors or warnings but it should complete. When this is done all of your old settings should have migrated over without much fanfare.

 [1]: http://labs.vmware.com/flings/inventorysnapshot "InventorySnapshot"
 [2]: wp-content/uploads/2012/12/InvSnap.jpg
 [3]: wp-content/uploads/2012/12/InvSnap2.jpg
 [4]: wp-content/uploads/2012/12/InvSnap3.jpg