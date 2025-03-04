---
title: Get Remote Shadow Volume Information With Powershell
author: Zachary Loeber
type: post
date: 2013-09-15T02:57:55+00:00
url: /blog/2013/09/14/get-remote-shadow-volume-information-with-powershell/
categories:
  - Microsoft
  - Powershell
  - Storage
  - System Administration
tags:
  - 2008 R2
  - Microsoft
  - Monitoring
  - network administration
  - Networking
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
Gather the remote shadow volume information for one or more systems using wmi, alternate credentials, and multiple runspaces. Function supports custom timeout parameters in case of wmi problems and returns shadow volume information, shadow copies, their providers, and settings. You can view verbose information on each runspace thread in realtime with the -Verbose option.

<!--more-->

### **Version History**

**1.0.0 &#8211; 09/14/2013**

  * Initial release

### Notes

I’m not entirely certain why yet, but it is possible to get shadow volume usage returned which is larger than the entire physical volume it is associated with (his will most likely be seen on backup servers with their own VSS providers).

### **Download**

[Download the script at the technet gallery.][1]

 [1]: http://gallery.technet.microsoft.com/Get-Remote-Shadow-Volume-e5a72619