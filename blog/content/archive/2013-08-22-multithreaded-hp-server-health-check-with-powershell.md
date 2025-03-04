---
title: Multithreaded HP Server Health Check with Powershell
author: Zachary Loeber
type: post
date: 2013-08-22T17:32:45+00:00
excerpt: 'This function attempts to query the HP WBEM WMI provider information to ascertain the general health of a physical server. The following components can be checked: ethernet teams, array controllers , ethernet adapters, fans, HBAs, power supplies, and temperature sensors.'
url: /blog/2013/08/22/multithreaded-hp-server-health-check-with-powershell/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Powershell
  - Reporting
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
## About

This function attempts to query the HP WBEM WMI provider information to ascertain the general health of a physical server. By default just the general health status is returned. Optionally you can include the following components in the results: ethernet teams, array controllers , ethernet adapters, fans, HBAs, power supplies, and temperature sensors.

<!--more-->

## **Version History**

**1.0.0 &#8211; 08/22/2013**

  * Initial release

## Notes

For obvious reasons, you will need to have the HP WBEM software installed on the server. But if you do not and the server is detected to be manufactured by HP, it will be detected and a warning will be displayed.

WBEM Provider Download: http://h18004.www1.hp.com/products/servers/management/wbem/providerdownloads.html

If you are troubleshooting this function your best bet is to use the hidden verbose option when calling the function. This will display information within each runspace at appropriate intervals.

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Multithreaded-HP-Server-f48080a3
 [2]: /wp-content/uploads/2013/08/Get-HPServerHealth.ps1