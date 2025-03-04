---
title: 'Lync 2013: Monitoring Mirrored SQL Databases With PowerShell'
author: Zachary Loeber
type: post
date: 2013-11-25T18:16:24+00:00
excerpt: Here is a PowerShell script I came up with to generate a report on the Lync 2013 database mirror, windows service, and replication statuses.
url: /blog/2013/11/25/lync-2013-monitoring-mirrored-sql-databases-with-powershell/
categories:
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Lync
  - Lync 2013
  - Microsoft
  - Monitoring
  - Powershell
  - Scripting
  - System Administration
  - Windows

---
In Lync 2013 you are given a powerful new backend redundancy option for your important databases in the form of SQL mirroring. In this article I’ll discuss which services are able to be mirrored, the databases they encompass, and provide a PowerShell script to generate a report on the database mirror status. I also threw in Lync CMS replication and service status sections because it is the civil thing to do&#8230;

<!--more-->

* * *

In picking through the backend changes between Lync 2010 and 2013 I found myself looking quite a bit more deeply into the new SQL mirroring support than I originally intended. The quick rundown of Lync database mirroring is that there are several Lync service types that are able to be setup for SQL mirroring. These services, in turn, consist of one or more databases which are actually mirrored between two sql servers. You can look at the status of your backend SQL database mirrors within the SQL management tool. Or you can also look at the status within the Lync server control panel by going to Topology -> Status, then selecting the properties of a server.

Unfortunately, there is a slight disconnect between the individual databases which are mirrored, the services that they map to, and the actual database servers which the primary (aka. principal) and mirrored databases reside. The services that a particular database map to is important to know as that is how database fail overs are manually managed within Lync (using Invoke-CsDatabaseFailover -PoolFqdn <_pool.domain.com>_ -DatabaseType _<Type>_).

As multiple databases can map to a single database type, it is also entirely possible to unknowingly be in a state where some databases are failed over to the mirror copy while others are still on the primary copy. A[ great blog post by James Cussen][1] has a list of Lync 2013 databases and their associated service types (aka. Database Types). He also covers the above mentioned SQL mirroring scenario quite well and provides an excellent GUI script for managing them

Partly driven by James&#8217;s contribution to the community and partly from frustration because of the lack of built in powershell cmdlet functionality, I’ve created a PowerShell function to better report on the lync pools, services, their database mirror state, and associated SQL servers. I then use this information to create a health report based on the state of the primary and mirror databases.

The actual function is quite simple. First we gather a list of Lync pools which are not on the edge and which require replication. This should get me all lync front-end/chat servers. Using these pool Fqdns I loop through and get the results of Get-CsDatabaseMirrorState. For each pool which returns any results I use a hash table of all the database names and their associated service to determine which command I’ll be running to get the primary and mirror database server information from (I could have just integrated this database name checking into the switch statement directly but this should be a more forward moving solution). I have to do this as, for whatever reason, Lync stores all the database server primary/mirror information with different property names in the Get-CSService output. This effectively gives me all the database mirror information and the pool, service, and associated SQL servers.

Here is the function:

<pre>Function Get-LyncDatabaseMirror
{
 Begin
 {</pre>

<pre>$pools = @()
 $dbServices = @{
 'rgsconfig' = 'Application'
 'rgsdyn' = 'Application'
 'cpsdyn' = 'Application'
 'lcslog' = 'Archiving'
 'xds' = 'CentralMgmt'
 'lis' = 'CentralMgmt'
 'mgc' = 'PersistentChat'
 'mgccomp' = 'PersistentChatCompliance'
 'rtcab' = 'UserServer'
 'rtcxds' = 'UserServer'
 'rtcshared' = 'UserServer'
 'lcscdr' = 'Monitoring'
 'qoemetrics' = 'Monitoring'
 }
 $dbs = @()
 $pools = @()
 }
 Process
 {}
 End
 {
 $pools = ((Get-CsTopology).Clusters | 
 Where {($_.RequiresReplication) -and (!$_.IsOnEdge)} | 
 %{[string]$_.Fqdn})
 Foreach ($pool in $pools)
 {
 $dbstates = Get-CsDatabaseMirrorState -PoolFqdn $pool
 if ($dbstates -ne $null)
 {
 foreach ($dbstate in $dbstates)
 {
 switch ($dbServices[[string]$dbstate.DatabaseName]) {
 'Application' {
 Get-CsService -PoolFqdn $pool -ApplicationServer | %{
 $PrimaryDBServer = (([string]$_.ApplicationDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorApplicationDatabase).Split(':'))[1]
 }
 }
 'Archiving' {
 Get-CsService -PoolFqdn $pool -Registrar | %{
 $PrimaryDBServer = (([string]$_.ArchivingDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorArchivingDatabase).Split(':'))[1]
 }
 }
 'Monitoring' {
 Get-CsService -PoolFqdn $pool -Registrar | %{
 $PrimaryDBServer = (([string]$_.MonitoringDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorMonitoringDatabase).Split(':'))[1]
 }
 }
 'CentralMgmt' {
 Get-CsService -PoolFqdn $pool -CentralManagement | %{
 $PrimaryDBServer = (([string]$_.CentralManagementDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorCentralManagementDatabase).Split(':'))[1]
 }
 }
 'PersistentChat' {
 Get-CsService -PoolFqdn $pool -PersistentChatServer | %{
 $PrimaryDBServer = (([string]$_.PersistentChatDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorPersistentChatDatabase).Split(':'))[1]
 }
 }
 'PersistentChatCompliance' {
 Get-CsService -PoolFqdn $pool -PersistentChatServer | %{
 $PrimaryDBServer = (([string]$_.PersistentChatComplianceDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorPersistentChatComplianceDatabase).Split(':'))[1]
 }
 }
 'UserServer' {
 Get-CsService -PoolFqdn $pool -UserServer | %{
 $PrimaryDBServer = (([string]$_.UserDatabase).Split(':'))[1]
 $MirrorDBServer = (([string]$_.MirrorUserDatabase).Split(':'))[1]
 }
 }
 default {
 $PrimaryDBServer = ''
 $MirrorDBServer = ''
 }
 }
 $dbprops = @{
 'Pool' = $pool
 'Application' = $dbServices[[string]$dbstate.DatabaseName]
 'Database' = $dbstate.DatabaseName
 'PrimaryState' = $dbstate.StateOnPrimary
 'MirrorState' = $dbstate.StateOnMirror
 'PrimaryDBServer' = $PrimaryDBServer
 'MirrorDBServer' = $MirrorDBServer
 }
 New-Object psobject -Property $dbprops
 }
 }
 }
 }
}</pre>

I’ve used this function along with a couple others I concocted to create a small Lync 2013 health report for your convenience that you can [download from the Microsoft Technet Gallery.][2] Here is a small part of the output (not shown are the associated pools and sql servers to the left and right):

<div id="attachment_1028" style="width: 238px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2013/11/Untitled.png"><img class="size-medium wp-image-1028" alt="Lync 2013 Mirrored Database Status" src="/wp-content/uploads/2013/11/Untitled.png?resize=228%2C300" width="228" height="300" srcset="/wp-content/uploads/2013/11/Untitled.png?resize=228%2C300 228w, wp-content/uploads/2013/11/Untitled.png?w=400 400w" sizes="(max-width: 228px) 100vw, 228px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Lync 2013 Mirrored Database Status
  </p>
</div>

 [1]: http://www.mylynclab.com/2013/05/lync-2013-database-mirror-manager-tool.html
 [2]: http://gallery.technet.microsoft.com/Lync-2013-Mirrored-SQL-132c2f06