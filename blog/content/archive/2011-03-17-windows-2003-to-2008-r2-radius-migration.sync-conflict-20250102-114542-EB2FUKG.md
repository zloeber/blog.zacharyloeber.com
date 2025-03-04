---
title: 'Windows: 2003 to 2008 R2 RADIUS Migration'
author: Zachary Loeber
type: post
date: 2011-03-17T12:58:12+00:00
excerpt: Windows 2003 IAS Radius server migration to 2008 R2 NPS note
url: /blog/2011/03/17/windows-2003-to-2008-r2-radius-migration/
categories:
  - Active Directory
  - Microsoft
  - Networking
  - Security
tags:
  - 2008 R2
  - Active Directory
  - Microsoft
  - Networking
  - NPS
  - Radius
  - Security
  - Sysadmin
  - System Administration
  - Windows

---
I found myself doing yet another Windows 2003 IAS Radius server migration to 2008 R2 NPS. I found that I had my prior notes and was able to do this quickly but, hell, if I&#8217;m looking this up in my own notes I may as well just post this succinct little procedure.

<!--more-->Copy %windir%\syswow64\iasmigreader.exe (this may also be on the installation media at \sources\dlmanifests\microsoft-windows-iasserver-migplugin) from the 2008 server to the 2003 server and run. It will spit out where the backup file was created. Copy this over

<pre>C:\&gt;IasMigReader.exe
Start to convert IAS configuration.
IAS configuration is successfully saved to "C:\WINDOWS\system32\IAS\ias.txt".</pre>

Copy the ias.txt file that is generated back to the 2008 R2 server and import the configuration like so:

At the 2008 R2 Server:

<pre>netsh nps import filename="path\ias.txt"
</pre>

Don&#8217;t forget to register your NPS service in AD or configuration settings be damned, NPS will just will not work.