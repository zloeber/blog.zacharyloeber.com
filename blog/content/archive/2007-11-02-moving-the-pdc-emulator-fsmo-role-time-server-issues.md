---
title: Moving the PDC Emulator FSMO Role – Time Server Issues
author: Zachary Loeber
type: post
date: 2007-11-02T17:16:26+00:00
url: /blog/2007/11/02/moving-the-pdc-emulator-fsmo-role-time-server-issues/
categories:
  - Microsoft
  - Networking
draft: false
---

I did not want this to be my first post but it needs to be posted out there somewhere for all to read.

There are plenty of documents out there on how to seize the FSMO roles in a windows 2003 domain controller, so I&#8217;ll not discuss how that is done. But many of them do not tell you a few extra steps needed if you are moving the PDC Emulator role and that server is (as it should be by default

<!--more-->

First of all you should have your main time server on the dc which is running this role. If you transfer PDC to another DC then do the following to the previous PDC Emulator at a command prompt:

> `w32tm /config /syncfromflags:domhier /reliable:no /update`

> `net stop w32time && net start w32time`

This is so that within the domain controller stops looking at itself as the time server (you set it to not be reliable and then to sync it&#8217;s time from a DC in the domain hierarchy)

Then Do this to the new PDC Emulator

> `w32tm /config /manualpeerlist:**_peers_ **/syncfromflags:manual /reliable:yes /update`
>
> (where _peers_ specifies the list of DNS names and/or IP addresses of the NTP time source that the PDC emulator synchronizes from. For example, you can specify my favorite _pool.ntp.org_. When specifying multiple peers, use a space as the delimiter and enclose them in quotation marks.)

This makes your new PDC emulator look outside the domain when time syncing and makes it reliable so that other DCs will grab time from it when looking for their updates.

You can get a quick view of your network time server settings with the following command:

> `w32tm /monitor`

There should not be any errors and they should all be pointing back to your PDC emulator which, in turn, points to your outside time source (which will change intermittently if you go to a pool of servers like pool.ntp.org)

All registry settings explained <a href="http://technet2.microsoft.com/windowsserver/en/library/b43a025f-cce2-4c82-b3ea-3b95d482db3a1033.mspx?mfr=true" title="here" target="_blank">here</a> for fine grain tuning of your time server settings.

Zach
