---
title: 'Exchange 2010 SP1: DAG Node Maintenance'
author: Zachary Loeber
type: post
date: 2010-11-04T20:22:18+00:00
url: /blog/2010/11/04/exchange-2010-sp1-dag-node-maintenance/
categories:
  - Exchange
  - Microsoft
  - Networking
  - System Administration

---
If you are performing maintenance on DAG nodes here is the process you want to go through (along with a slight caveat to fix a possible active copy move issue you may run into). In my environment I have three nodes in a cross-site dag.

All the commands below are run in an administrative exchange powershell prompt.

<!--more-->

**Process for running maintenance on exchange database servers**

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StartDagServerMaintenance.ps1" -ServerName &lt;Dag Node 1&gt;</pre>

  * Run maintenance on <Dag Node 1>

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StopDagServerMaintenance.ps1" -ServerName &lt;Dag Node 1&gt;</pre>

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StartDagServerMaintenance.ps1" -ServerName &lt;Dag Node 2&gt;</pre>

  * run maintenance on <Dag Node 2>

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StopDagServerMaintenance.ps1" -ServerName &lt;Dag Node 2&gt;</pre>

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StartDagServerMaintenance.ps1" -ServerName &lt;Dag Node 3&gt;</pre>

  * run maintenance on <Dag Node 3>

<pre>& "C:\Program Files\Microsoft\Exchange Server\V14\scripts\StopDagServerMaintenance.ps1" -ServerName &lt;Dag Node 3&gt;</pre>

When done performing maintenance on one or multiple servers (hopefully one at a time to maintain full database availability for end users!) you can end up with a sub-optimal active database layout, especially if you have a cross-site DAG. To resolve this you have to rebalance the databases based on the priorities set for them upon creation.

**Rebalance databases across dag**

<pre>& “C:\Program Files\Microsoft\Exchange Server\V14\scripts\RedistributeActiveDatabases.ps1”
-DagName &lt;Your DAG Name&gt; -BalanceDbsByActivationPreference -ShowFinalDatabaseDistribution -Confirm:$false</pre>

 ****

If you get any errors you may have to re-index the search catalog for the passive database. Rather than hunting down which ones need to be fixed you can just fix them all with the custom script I wrote below (or for only the mail servers with issues). When finished running these commands then try to run the maintenance or rebalance scripts again.

**Fix/Rebuild Search Catalogs**

<pre>Get-MailboxDatabaseCopyStatus -Server &lt;Dag Node 1&gt; | where {$_.Status -like "Healthy"} | Update-MailboxDatabaseCopy -catalogonly</pre>

<pre>Get-MailboxDatabaseCopyStatus -Server &lt;Dag Node 2&gt; | where {$_.Status -like "Healthy"} | Update-MailboxDatabaseCopy -catalogonly</pre>

<pre>Get-MailboxDatabaseCopyStatus -Server &lt;Dag Node 3&gt; | where {$_.Status -like "Healthy"} | Update-MailboxDatabaseCopy -catalogonly</pre>