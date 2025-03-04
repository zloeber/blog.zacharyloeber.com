---
title: Multithreaded System Asset Gathering with Powershell
author: Zachary Loeber
type: post
date: 2013-08-05T17:35:31+00:00
url: /blog/2013/08/05/multithreaded-system-asset-gathering-with-powershell/
categories:
  - Microsoft
  - Networking
  - Powershell
  - Security
  - System Administration
tags:
  - 2008 R2
  - Monitoring
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
This function gathers a plethora of useful system information via WMI and multithreading with powershell.

<!--more-->

**About**

I took another script and modified it to suit my needs for yet another personal project I’m working on. This is the result.

**Version History**

**1.1.0 &#8211; 8/3/2013**

· Added several parameters

· Removed parameter sets in favor of arrays of custom object as note properties

· Removed ICMP response requirements

· Included more verbose runspace logging

 **1.0.2 &#8211; 8/2/2013**

· Split out system and OS architecture (changing how each it determined)

 **1.0.1 &#8211; 8/1/2013**

· Updated to include several more bits of information and customization variables

 **1.0.0 &#8211; ???**

· Discovered original script on the internet and totally was blown away at how awesome it is.

**Notes**

WMI prefered over CIM as there no speed advantage using cimsessions in multithreading against old systems. Starting around line 263 you can modify the WMI_Props arrays to include extra wmi data for each element should you require information I may have missed. You can also change the default display properties by modifying $defaultProperties. Keep in mind that including extra elements like the drive space and network information will increase the processing time per system. You may need to increase the timeout parameter accordingly.

**Script**

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Multithreaded-System-Asset-856a8f7c
 [2]: /wp-content/uploads/2013/08/Get-ComputerAssetInformation.ps1