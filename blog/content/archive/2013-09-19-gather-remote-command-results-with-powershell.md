---
title: Gather Remote Command Results With Powershell
author: Zachary Loeber
type: post
date: 2013-09-19T16:22:41+00:00
url: /blog/2013/09/19/gather-remote-command-results-with-powershell/
categories:
  - Microsoft
  - Networking
  - Powershell
  - Security
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
Send a remote command using wmi, alternate credentials, and multiple runspaces then retrieve the results serially using mapped secure channels to the remote host. The remote command execution function supports custom timeout parameters in case of wmi problems and returns the remote tmp file information containing the command results. You can view verbose information on each runspace thread in realtime with the -Verbose option.

<!--more-->

### Version History

**1.0.1 – 09/19/2013**

  * I made a mistake with comparison of empty credentials which I&#8217;ve since resolved.
  * As an additional gift for the above mistake I included a function to return the remote hosts file as another example. Enjoy!

**1.0.0 – 09/19/2013**

  * Initial release

### Notes

I’m hanging onto the last thread (pun intended) when it comes to using dcom based system information/auditing methodologies in powershell in an effort to support the most legacy OSes as possible. This truly shows in this set of functions.  It is easy enough to send a remote command to be executed utilizing alternate credentials but getting the results of the command is a total pain in the rear. I’m almost certain this is part of the reason I see remnants of psexec installed everywhere.

I really dislike having to install extra software or leave any footprint at all when assessing an environment so using something like psexec or other agents is out of the question. To top it off there are some bits of information I like to gather which is really difficult, if not outright impossible, to do with WMI alone. A good example is VSS information. WMI exposes all kinds of nice info about shadow copies, providers, and volumes but nothing at all about writers. So I need to use vssadmin to gather this type of information, but vssadmin does not support remote systems or alternate credentials.

I looked around and finally settled on a two part method around this conundrum. First, I’ll use standard WMI to execute a command on the remote system (win32_process), with cmd.exe /c and pipe the results to that system’s temp directory. I can do this in multiple runspaces which return a result containing the remote location of the file containing the command output. I then take this output and create secure channel mappings (the IPC$ share) of the remote system locally with alternate credentials. This is a drive mapping of sorts but without any drive letters (bonus!). I then copy the file contents of the remote system output using standard powershell, remove the temp file, and close the secure channel. You end up with all the remote command output at your fingertips to process as you like.

The second part needs to be done serially but it is still quite fast to process.

Oh, As a special treat I’ve included a third function to process and return powershell object ready vss writer information from information gathered using the first two functions.

### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Gather-Remote-VSS-Writer-c0a81f3c
 [2]: /wp-content/uploads/2013/09/Get-RemoteCommandOutput1.ps1