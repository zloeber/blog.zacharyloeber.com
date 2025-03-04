---
title: Gather Local Group Membership With Powershell
author: Zachary Loeber
type: post
date: 2013-09-11T14:11:52+00:00
excerpt: Gather system local groups and their members for one or more systems using wmi, alternate credentials, and multiple runspaces.
url: /blog/2013/09/11/gather-local-group-membership-with-powershell/
categories:
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - 2008 R2
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Security
  - Sysadmin
  - System Administration
  - Windows

---
Gather system local groups and their members for one or more systems using wmi, alternate credentials, and multiple runspaces. Function supports custom timeout parameters in case of wmi problems, a switch for inclusion of empty groups in the results, and returns group names with their members. You can view verbose information on each runspace thread in realtime with the -Verbose option.

### **Version History**

**1.0.0 &#8211; 09/11/2013**

  * Initial release

### Notes

None, this is an independent release of a function I’ve recently included in a larger project.

### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

<a style="line-height: 1.6;" href="/wp-content/uploads/2013/09/Get-RemoteGroupMembership.ps1">Download the script from this site (less frequently updated)</a>

 [1]: http://gallery.technet.microsoft.com/Gather-Local-Group-0d0a85ad