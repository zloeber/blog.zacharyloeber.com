---
title: 'AD Audit Report with Powershell: Part 3'
author: Zachary Loeber
type: post
date: 2014-01-11T04:16:29+00:00
url: /blog/2014/01/10/ad-audit-report-with-powershell-part-3/
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Lync
  - MSCS
  - Networking
  - Office Communicator Server
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Exchange
  - Lync
  - Powershell
  - PSC
  - System Administration

---
This is my third and final major update to my AD auditing script. This includes a handful of new useful sections such as domain published printers, NPS servers, DHCP servers, as well as SCCM sites and DPs. Other improvements include easier to use script parameters and bug fixes.

<!--more-->

Here is a general list of improvements in version 1.6 of the script:

  * Added registered NPS devices
  * Added registered DHCP devices
  * Added domain registered print devices
  * Added SCCM servers and sites
  * Added wrapper parameters to entire script with some most used options for directly running the script from a powershell prompt.
  * Added ability to prompt for input for all major global variables.
  * Fixed verbose calling for priv groups and users
  * Updated lastlogontimestamp for user export normalization to show never logged in instead of a date from the 1600&#8217;s.
  * Added date translation for account expiration in account normalization
  * Updated ad gathering functions to account for inability to connect to a domain and silently exit.
  * Slight rearrangement of report sections.

Unless I missed anything really cool in AD which can be gathered with a regular domain user, this will be my last major update to this script. Get [the updated script at the Microsoft Technet Gallery][1]. As always I welcome feedback.

 [1]: http://gallery.technet.microsoft.com/Active-Directory-Audit-7754a877