---
title: Gather Applied GPOs from Remote Systems With Powershell
author: Zachary Loeber
type: post
date: 2013-09-04T04:16:09+00:00
excerpt: Gather the applied GPO information for one or more systems using wmi, alternate credentials, and multiple runspaces.
url: /blog/2013/09/03/gather-applied-gpos-from-remote-systems-with-powershell/
categories:
  - Active Directory
  - Microsoft
  - Powershell
  - Security
  - System Administration

---
Gather the applied GPO information for one or more systems using wmi, alternate credentials, and multiple runspaces. Function supports custom timeout parameters in case of wmi problems and returns GPO name, applied order, source, no override settings, and more. You can view verbose information on each runspace thread in realtime with the -Verbose option.

<!--more-->

### **Version History**

**1.0.0 – 09/01/2013**

  * Initial release

### Notes

Only note for this function is that it was a plesant surprise to find out how easy it is to get applied GPO information on a system with powershell and wmi. It is really cool information to gather when troubleshooting GPO related issues or for better understanding your environment. I guess another note would be that I drop all the applie GPO information in an array of PSObjects as a noteproperty within the returned object (as AppliedGPOs). This is largely to make it easier to parse resulting output when being run against multiple systems concurrently (more releases coming soon which will better illustrate what I mean).

### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Gather-Applied-GPOs-from-74250d0e
 [2]: /wp-content/uploads/2013/09/Get-RemoteAppliedGPOs.ps1