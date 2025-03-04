---
title: 'Exchange 2010: Poor Man’s Monitoring'
author: Zachary Loeber
type: post
date: 2012-07-22T20:11:16+00:00
excerpt: 'I released Troubleshoot-MailboxServer.ps1. This script is meant for monitoring, fixing, and reporting on Exchange 2010 database servers. It pretty much just wraps around and reports on the automating the troubleshooting scripts found in %ExchangeInstallPath%Scripts\. You can have an email sent including warning/error color coded report upon completion. '
url: /blog/2012/07/22/exchange-2010-poor-mans-monitoring/
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - Storage
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Monitoring
  - Powershell
  - System Administration

---
I quietly released a new script into the wild the other day, Troubleshoot-MailboxServer.ps1. This script is meant for monitoring, fixing, and reporting on Exchange 2010 database servers. It pretty much just wraps around and reports on troubleshooting scripts found in %ExchangeInstallPath%Scripts\. I also set it so you can have an email sent including warning/error color coded report upon completion.

<!--more-->

Optionally, an overall system health overview can be sent following any warnings/errors which are generated from the scripts. This last report is purely optional and is actually just another person’s script which I rolled into Troubleshoot-MailboxServer.ps1. This report has some external requirements though. [The original author’s release of the script can be read here][1]. The external requirements are [MS Chart Controls for .Net 3.5][2]. So if you are not wanting to install these requirements on your Exchange server then make certain to set $SendSystemReport to $false.

The scripts which Troubleshoot-MailboxServer.ps1 calls are as follows:

  * Troubleshoot-CI.ps1 (I cannot seem to find the ms technet article for this one)
  * [Troubleshoot-DatabaseLatency.ps1][3]
  * [Troubleshoot-DatabaseSpace.ps1][4]

More information about the [Exchange 2010 Troubleshooters can be found here.][5]

For good measure I tossed in the option to redistribute your DAG(s) with [RedistributeActiveDatabases.ps1][6].

Be cautioned that, although this script does have a “testing” mode, it does not prevent the troubleshooter scripts from disabling provisioning of mailboxes to databases as that feature is not available as part of the troubleshooter scripts. Should you find that databases have become unprovisionable and you want the ability to provision to them again you need to run the following from an Exchange 2010 management shell:

<pre>Set-MailboxDatabase &lt;database name&gt; -IsExcludedFromProvisioning:$false</pre>

In Exchange 2010 SP1 the CheckDatabaseRedundancy.ps1 script is included and scheduled to automatically run. Apparently they used ManageScheduledTask.ps1 (which is also new to SP1) to automate scheduling the task. As when you use ManageScheduledTask.ps1 the description given to any new scheduled task you create with it reads that it is a task for checking database redundancy J. Regardless, you can use that script to schedule Exchange-DatabaseMonitoring.ps1.

<pre>cd $exscripts</pre>

<pre>.\ManageScheduledTask.ps1 -Install -ServerName &lt;Your Server&gt; -PsScriptPath C:\Scripts\Troubleshoot-MailboxServer.ps1 -TaskName "Troubleshoot Exchange 2010 Mailbox Servers"</pre>

(Note: this adds the scheduled task as a generic task, you will still need to go into scheduled tasks  and set a schedule for it to run and add change the description).

Download the script: [Troubleshoot-MailboxServer.ps1][7]

or

<p class="MsoNoSpacing">
  <a title="Troubleshoot-MailboxDatabase on Technet script center" href="http://gallery.technet.microsoft.com/scriptcenter/Troubleshoot-Exchange-2010-aecdc23f">From here</a>
</p>

 [1]: http://www.simple-talk.com/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/
 [2]: http://www.microsoft.com/download/en/details.aspx?id=14422
 [3]: http://technet.microsoft.com/en-us/library/ff798271
 [4]: http://technet.microsoft.com/en-us/library/ff477617.aspx
 [5]: http://blogs.technet.com/b/exchange/archive/2011/01/18/3411844.aspx
 [6]: http://technet.microsoft.com/library/dd335158%28v=EXCHG.141%29
 [7]: /wp-content/uploads/2012/07/Troubleshoot-MailboxServer.ps1