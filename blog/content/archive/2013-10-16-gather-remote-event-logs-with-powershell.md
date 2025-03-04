---
title: Gather Remote Event Logs With Powershell
author: Zachary Loeber
type: post
date: 2013-10-16T17:01:13+00:00
excerpt: Gather the remote event log information for one or more systems using wmi, alternate credentials, and multiple runspaces.
url: /blog/2013/10/16/gather-remote-event-logs-with-powershell/
categories:
  - Powershell
  - Security
  - System Administration
tags:
  - Microsoft
  - network administration
  - Networking
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
### About

Gather the remote event log information for one or more systems using wmi, alternate credentials, and multiple runspaces. Function supports custom timeout parameters in case of wmi problems and returns Event Log information for the specified number of past hours. You can view verbose information on each runspace thread in realtime with the -Verbose option.

### **Version History**

**1.0.0 &#8211; 10/16/2013**

  * Initial release

### Notes

By default 24 hours is what we filter against for the results. I’m retroactively releasing this function individually from the new-assetreport project I’ve released a little while ago.

### Downloads

[Download the script from the technet gallery.][1]

 [1]: http://gallery.technet.microsoft.com/Get-Remote-Event-Logs-With-35a3a58e