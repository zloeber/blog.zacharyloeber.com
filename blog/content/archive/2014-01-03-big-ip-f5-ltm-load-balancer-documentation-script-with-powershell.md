---
title: Big-IP F5 LTM Load Balancer Documentation Script with Powershell
author: Zachary Loeber
type: post
date: 2014-01-03T18:11:18+00:00
excerpt: Here is a script I whipped up to perform a report on your Big-IP LTM load balancers using powershell. The report currently includes the virtual servers, pools, and various bits of status information on both. Big-IP iControl modules are needed (for obvious reasons).
url: /blog/2014/01/03/big-ip-f5-ltm-load-balancer-documentation-script-with-powershell/
categories:
  - BIG-IP
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - Big-IP
  - F5
  - Load balancing
  - LTM
  - Powershell
  - PSC
  - System Administration

---
Here is a script I whipped up to perform a report on your Big-IP LTM load balancers using powershell. The report currently includes the virtual servers, pools, and various bits of status information on both. [Big-IP iControl modules][1] are needed (for obvious reasons).

<!--more-->

### Details

The following information is gathered and shown in the report which is generated:

  * Virtual Server Summary 
      * Virtual server name
      * Address
      * Port
      * Pool
      * Enable state
      * Availability
  * Virtual Server Details 
      * Virtual server name
      * Persistence profile
      * iRules
  * Pools 
      * Pool name
      * Active members
      * Enable state
      * Availability
      * Load balance method
  * Pool Members 
      * Pool name
      * Address
      * Port
      * Total connections
      * Current connections
      * Bytes in
      * Enable state
      * Availability

### Version

Version 1.0.0 &#8211; 01/02/2014

  * Initial Release

### Notes

  * The script requires powershell 3.0 as well as .Net 3.5 for Linq to be able to highlight HTML table cells.
  * I&#8217;ve decided to try out something new and put a wrapper around the entire script to allow for calling the script directly from a powershell console without modification. This gives you the most common report options with as few parameters as possible and should help simplify usage. To run the script without any modifications at all simply run it with the -PromptForInput option.

### Screenshots

<img style="margin: 5px;" alt="" src="http://i1.gallery.technet.s-msft.com/big-ip-f5-ltm-load-3fc9a2af/image/file/106436/1/2014-01-03%2011_26_44-system%20report.jpg?resize=585%2C194" width="585" height="194" data-recalc-dims="1" />

<img style="margin: 5px;" alt="" src="http:///i1.gallery.technet.s-msft.com/big-ip-f5-ltm-load-3fc9a2af/image/file/106437/1/2014-01-03%2011_29_13-system%20report.jpg?resize=577%2C149" width="577" height="149" data-recalc-dims="1" />

<img style="margin: 5px;" alt="" src="http:///i1.gallery.technet.s-msft.com/big-ip-f5-ltm-load-3fc9a2af/image/file/106438/1/2014-01-03%2011_29_57-system%20report.jpg?resize=576%2C101" width="576" height="101" data-recalc-dims="1" />

### Download

Download the most recent version of this script [at the Microsoft Technet Gallery][2]

 [1]: https://devcentral.f5.com/d/microsoft-powershell-with-icontrol
 [2]: http://gallery.technet.microsoft.com/Big-IP-F5-LTM-Load-3fc9a2af