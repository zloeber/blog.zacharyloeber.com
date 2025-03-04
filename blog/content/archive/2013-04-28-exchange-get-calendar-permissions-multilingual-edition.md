---
title: 'Exchange: Get Calendar Permissions (multilingual edition)'
author: Zachary Loeber
type: post
date: 2013-04-28T17:35:54+00:00
excerpt: The built in commands for attaining mailbox folder permissions assumes you know the localized spelling of the calendar sub-folder. An example is an organization which may have users in Mexico and the US. What this script does is pull the calendar name based on the mailbox localization, enumerates all the permissions using that name, and returns an array of psobjects with the mailbox, user, and assigned permissions.
url: /blog/2013/04/28/exchange-get-calendar-permissions-multilingual-edition/
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - Scripting
  - Security
  - System Administration

---
Some time ago I released [a rather simplistic GUI for viewing Exchange 2010 mailbox calendar permissions][1]. Because of a semi-related script I&#8217;m working on currently I rounded back and recreated that GUI script to be a powershell function instead. This is the result.

<!--more-->

# Description

The built in commands for attaining mailbox folder permissions assumes you know the localized spelling of the calendar sub-folder. An example is an organization which may have users in Mexico and the US. What this script does is pull the calendar name based on the mailbox localization, enumerates all the permissions using that name, and returns an array of psobjects with the mailbox, user, and assigned permissions.

# Version History

1.1.0 April 24 2013    :    Used new script template from http://blog.bjornhouben.com
  
1.0.0 March 10 2013  :   Created script

# Download

[Get-CalendarPermission.ps1 on TechNet Gallery][2]

 [1]: http://gallery.technet.microsoft.com/Exchange-2010-Calendar-21695fde "Exchange 2010 Calendar Permission GUI"
 [2]: http://gallery.technet.microsoft.com/Get-Exchange-Calendar-5bb4f527