---
title: 'Exchange 2010: Client Access Role Configuration Report'
author: Zachary Loeber
type: post
date: 2012-02-04T14:03:29+00:00
excerpt: A client access setting report script for Exchange 2010 which includes all internal and external paths along with their authentication settings.
url: /blog/2012/02/04/exchange-2010-client-access-role-configuration-report/
categories:
  - Exchange
  - Exchange 2010
  - IIS
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Powershell
  - Scripting

---
Ok, so I woke up and was wide awake at 4am this morning. I took it as a sign to lose my mind for a while and get to hacking another script. The result is a client access setting report script which includes all internal and external paths along with their authentication settings. It needs some prettying up and a bit of love but it does exactly what I&#8217;ve wanted in Exchange 2010, gives me an overall view of all client access settings (specifically related to IIS). Enjoy.

[Get-Exchange2010CASURL.ps1 for reporting enjoyment][1]

 [1]: /wp-content/uploads/2012/02/Get-Exchange2010CASURL.ps1 "get-exchange2010CASURL.ps1"