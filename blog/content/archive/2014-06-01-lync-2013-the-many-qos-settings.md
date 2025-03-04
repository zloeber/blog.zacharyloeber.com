---
title: 'Lync 2013: The Many QoS Settings'
author: Zachary Loeber
type: post
date: 2014-06-01T15:13:00+00:00
excerpt: Gather a list of applicable Lync servers (mediation, frontend, and edge), gather QoS settings both from server local registries and from the Lync enterprise policies and display them on the console.
url: /blog/2014/06/01/lync-2013-the-many-qos-settings/
categories:
  - Lync
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - Lync
  - Lync 2013
  - Powershell
  - PSC
  - QoS

---
There are more than a few QoS settings in Lync 2013. Here is a script which should gather most of them in a human readable format for your convenience.

<!--more-->

### Introduction

I’ve come to realize just how many Lync 2013 settings are part of an enterprise deployment. Aside from ensuring that your chosen QoS settings are being adhered to end to end across your network there are multiple areas within Lync and the registry that you need to have aligned in order for quality of service to really work the way it should.

The policies which you might need to cognizant of are as follows:

  * Conferencing Server/Pool Policies
  * Mediation Server/Pool Policies
  * Conferencing Client Policies
  * Non-Windows based UC Device Policies (think VVX series polycom phones or other such devices where you might be manually setting QoS or at least managing it outside of Lync)
  * Windows based UC Device Policies (Like CX series polycom phones)

Those were just the policy driven Lync settings. You also need to ensure that your servers are setup for QoS networking appropriately, typically via GPO. The internal frontend/conferencing/mediation servers need to have local ports set with the appropriate DSCP values. The edge servers need to have remote ports set with the same DSCP values. And they both need to have network location awareness disabled.

**Note:** One area that I’ve not mentioned is the [Lync clients running on Windows workstations][1]. I couldn’t easily figure out a way to test that this has been set appropriately but the function in the script I’ve created, Get-ServerQosSettings, should allow you to script this portion out yourself.

### Script

In order to help gather some of this information in one spot I put this script together. It should help you isolate overlapping port ranges, servers without local network QoS settings applied, and policies which are not set. The script first pulls all policy driven Lync backend settings. It then tries to determine your edge and internal servers and remotely parse their registry for the appropriate local QoS settings.

I feel badly that I didn’t make this a really pretty HTML report but honestly this is not something you should need to have regularly reported on. Once you setup QoS appropriately a regular report on its settings should produce the exact same results repeatedly. Besides, I’m still ironing out several aspects for the next round of updates to my Powershell reporting engine and I didn’t feel like messing around with it.

As usual, you can download the [updated script from the Microsoft Technet Gallery][2]. I welcome any feedback you might have.

 [1]: http://technet.microsoft.com/en-us/library/jj205371.aspx
 [2]: http://gallery.technet.microsoft.com/Lync-2013-QoS-Settings-03917cf5