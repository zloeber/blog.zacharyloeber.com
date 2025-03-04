---
title: Determine if a computer is virtual with powershell
author: Zachary Loeber
type: post
date: 2013-07-26T18:22:43+00:00
url: /blog/2013/07/26/determine-if-a-computer-is-virtual-with-powershell/
categories:
  - Microsoft
  - Powershell
  - System Administration
  - Virtualization
  - VMware
tags:
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - System Administration
  - virtualization
  - vmware
  - Windows

---
This function attempts to connect to a computer and find out if it is virtual or not using WMI. If it is virtual, a best guess at the type of virtual platform it is running upon is returned as well.

<!--more-->

## Versions

1.0.0 July 27th 2013

&#8211; Initial release

## Notes

This is a pretty simple function I whipped together to have in my ever growing library. This script parses wmi for bios version and a few other bits of information in order to guess if it is running as a virtual machine. You can pass alternate credentials if needed. A few extra bits of information are returned just in case it is needed.

## Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Determine-if-a-computer-is-cdd20473
 [2]: /wp-content/uploads/2013/07/Get-RemoteServerVirtualStatus.ps1