---
title: Enhanced Remote Server Connectivity Testing With Powershell
author: Zachary Loeber
type: post
date: 2013-06-25T14:22:18+00:00
url: /blog/2013/06/25/enhanced-remote-server-connectivity-testing-with-powershell/
categories:
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
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
Test the following connectivity methods to a server: RDP, ping, rpc, wsman, sccm agent, scom agent, and remote registry. Optionally an alternate credential can be used. Versatility is added with options to return only true/false when singular tests are performed.

<!--more-->

#### Description

There are several methods to test server connectivity prior to performing remote administration. This function bundles up some of the most pertinent methods into one versatile tool. You can test any combination of the following remote connectivity methods:

  * RDP
  * Ping
  * RPC (WMI)
  * WSman
  * SCCM agent (and site)
  * SCOM agent (and management groups)
  * Remote Registry

This function was a result of personally not being satisfied with test-connection (a simple ping test) and not liking to put in wmi or other testing hacks repeatedly. This script also provides the ability to pass alternate credentials (a feature I’m undeniably fond of).

#### Version

Version : 1.0.0 June 24th 2013
  
&#8211; First release

#### Notes

  * This is a heavily modified version of the script found here: http://gallery.technet.microsoft.com/scriptcenter/Powershell-Test-RemoteServer-e0cdea9a
  * Be aware that if the DNS lookup for the tested host returns multiple IP addresses all IP addresses will be tested and multiple results will be returned.
  * If a particular test is not performed and TrueFalseMode is not active then the associated property is returned as blank within a custom object.
  * TrueFalseMode has no effect if multiple tests are specified when calling the function.
  * The RDP test is only a port test.
  * The RPC/WMI test fails if it does not properly authenticate. If this test does succeed then it also automatically updates the returned hostname and domain.
  * The WSman test is a simple connectivity test without authentication.
  * The remote registry actually tests the remote registry service is running, thus WMI must test as running for the remote registry test to succeed. The same goes for the SCCM/SCOM tests. Coincidentally, if the RPC test fails and TrueFalseMode is not in effect then all tests related to wmi connectivity will be set to false.
  * The SCOM groups result will not work with alternate credentials (yet!)

#### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Enhanced-Remote-Server-84c63560
 [2]: /2013/06/23/use-powershell-to-gather-diskpartitionmount-point-information/ "Use Powershell to Gather Disk/Partition/Mount Point Information"