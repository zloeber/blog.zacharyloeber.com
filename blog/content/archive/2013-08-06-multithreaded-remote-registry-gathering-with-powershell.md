---
title: Multithreaded Remote Registry Gathering with Powershell
author: Zachary Loeber
type: post
date: 2013-08-07T03:11:49+00:00
url: /blog/2013/08/06/multithreaded-remote-registry-gathering-with-powershell/
categories:
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - 2008 R2
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
Gather specific subkey values or an entire registry key’s subkey values with powershell and multithreading.

<!--more-->

## Introduction

I’ve become a bit enamored with a multithreaded function I found recently on the Internet. (After reading through a good portion of the Powershell Deep Dive book I’m almost certain the roots of that function are from the legendary Boe Prox). Using this function as a template I’ve [released my own function][1] which gathers several bits of system information from WMI using within runspaces. As gathering remote registry information is really just a wmi connection I modified this same script to gather anything from a remote system’s registry as well. This is the resulting function.

As always (in my general scripts at least), this function supports supplying or prompting for alternate credentials. The default examples included in the comment based help show a very nice use case scenario for such a multithreaded powershell function, gathering remote time server information from a server. If you had to do this for 800 servers then this might be very handy indeed.

Many times you may need more than just one subkey value from a remote registry so instead of adding additional connections and processing I included the ability to just skip the subkey altogether and return all of the subkey values found under the key instead.

## Downloads

[Download the script from the technet gallery (more frequently updated)][2]

[Download the script from this site (less frequently updated)][3]

 [1]: /2013/08/05/multithreaded-system-asset-gathering-with-powershell/
 [2]: http://gallery.technet.microsoft.com/Multithreaded-Remote-ca714e12
 [3]: /wp-content/uploads/2013/08/Get-RemoteRegistryInformation.ps1