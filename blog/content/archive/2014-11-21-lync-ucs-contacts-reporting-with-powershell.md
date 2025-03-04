---
title: Lync UCS Contacts Reporting with Powershell
author: Zachary Loeber
type: post
date: 2014-11-21T17:37:30+00:00
excerpt: This powershell function returns UCS enabled Lync contacts as objects.
url: /blog/2014/11/21/lync-ucs-contacts-reporting-with-powershell/
categories:
  - Exchange 2013
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2013
  - Lync
  - Lync 2013
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - System Administration

---
By default a Lync enabled account within a Lync/Exchange 2013 environment will be enabled for UCS (Unified Contact Store). This means that the Lync contacts get saved in the Lync user&#8217;s mailbox and not the Lync database. In order to get a list of the contacts associated with these accounts you have to export data to a zip file with some debug Lync commands and, even then, the information is buried in a hard to interpret XML file.

I had a need to validate the contacts which were getting stored in UCS for Lync users and so I came up with this script to accomplish the task. It creates a temporary directory and exports all the passed Lync users&#8217; UCS contact information in a zip file within the directory. The function then parses and returns psobjects with the contact information by reading in the xml file directly from the zip file (no extraction to disk). After returning contact information back as nicely formatted powershell objects the temporary files are all cleaned up.

Here are a few small examples of what can be done:

<pre class="lang:powershell decode:true ">.EXAMPLE 
$a = Get-LyncUCSContacts test* 
 
Description 
----------- 
Get all ucs contact information for all lync and ucs enabled users in the environment matching the name test* 
 
.EXAMPLE 
Get-CSUser -Resultsize Unlimited | Get-LyncUCSContacts | Export-CSV -NoTypeInformation UCSContacts.csv</pre>

You can download this script at the [Microsoft Technet Gallery][1] or at my [new Github repo][2].

 [1]: https://gallery.technet.microsoft.com/Lync-UCS-Contacts-834819a1
 [2]: https://github.com/zloeber/Powershell/blob/master/Lync/Get-LyncUCSContacts.ps1