---
title: Gather Remote Installed Programs With Powershell
author: Zachary Loeber
type: post
date: 2013-08-28T13:25:22+00:00
url: /blog/2013/08/28/gather-remote-installed-programs-with-powershell/
categories:
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration

---
<span style="line-height: 1.6;">Gather program install information for one or more systems using wmi, alternate credentials, and multiple runspaces. Function supports custom timeout parameters in case of wmi problems and returns from the registry program name, manufacturer, and uninstall information. You can view verbose information on each runspace thread in realtime with the -Verbose option.</span>

<!--more-->

###  **Version History**

**1.0.0 &#8211; 08/27/2013**

  * Initial release

### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Gather-Remote-Installed-b78c26d3
 [2]: /wp-content/uploads/2013/08/Get-RemoteInstalledPrograms.ps1