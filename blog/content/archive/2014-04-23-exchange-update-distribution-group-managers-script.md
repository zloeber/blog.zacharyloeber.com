---
title: 'Exchange: Update Distribution Group Managers Script'
author: Zachary Loeber
type: post
date: 2014-04-24T00:26:37+00:00
excerpt: A small script to automatically update distribution group owners based on an AD security group.
url: /blog/2014/04/23/exchange-update-distribution-group-managers-script/
categories:
  - Exchange
  - Exchange 2010
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - PSC

---
A small script to automatically update distribution group owners based on an AD security group.

<!--more-->

Not much to the script really. This was a quick solution to an issue I ran into in the wild. A supplied security group will be unrolled and any account within which is also mail enabled and not already listed as a manager for the supplied distribution group will be automatically added to the managedby attribute list for the distribution group. If no distribution group is supplied then all distribution groups will be evaluated and updated.

This is really meant to help allow helpdesk or other staff to manage Exchange distribution lists from within the Exchange ECP. Otherwise they may have to resort to powershell in order to force management bypass checks when modifying distribution group membership.

In many regards this script is just a simplified version of an already [published solution found here][1].

Anyway, [here is the modified solution I came up with][2]. Enjoy!

 [1]: http://gallery.technet.microsoft.com/756b02bd-fb8c-4071-b7b3-3e9022831678
 [2]: http://gallery.technet.microsoft.com/Exchange-Update-Distributio-788dd3f0