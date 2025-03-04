---
title: Retrieve Remote Scheduled Task Information With Powershell
author: Zachary Loeber
type: post
date: 2013-10-06T23:32:48+00:00
url: /blog/2013/10/06/retrieve-remote-scheduled-task-information-with-powershell/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - 2008 R2
  - Microsoft
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
This function uses multiple runspaces with along with COM objects to gather information about the scheduled tasks of remote systems. Getting this to work with alternate credentials may be possible but I wasn’t able to discern a usable method to make it happen so I resorted to PSremoting. What this means is that this script will work against multiple remote systems which do not have psremoting enabled as long as you are running the script with an account that has administrative rights to them. If you do pass a credential to the function then psremoting will be used instead. You can also force psremoting to be used if you are using that across the board in your environment.

<!--more-->

This function was constructed in a way where it will utilize multiple runspaces along with PSremoting as the remote access method (one per invoked scriptblock). This comes at a slight performance hit in comparison to just running invoke-command and passing it all the systems in one command (at least in my limited testing of no more than several machines).  If all you use in your environment is PSremoting it would take a nominal amount of effort to strip just the scriptblock from this function for a direct call from invoke-command.

The one aspect about this script I regret is the inability to get scheduled tasks from a remote system which is not setup for PSremoting with a different credential. I suppose a third method of using wmi to execute a remote command (schtasks) which gets piped to a file for remote parsing would be feasible as well. But you don’t really get near as much scheduled task information that way and I really wanted to start incorporating PSremoting anyway. Besides, that can be done by anyone with a simple parsing function (in conjunction with the scripts [I already released to facilitate remote command output retrieval][1]).

### Version History

1.0.0 &#8211; 10/04/2013

  * Initial release

### Notes

I used code from a few sources to create this script;

  * http://p0w3rsh3ll.wordpress.com/2012/10/22/working-with-scheduled-tasks/
  * http://gallery.technet.microsoft.com/Get-Scheduled-tasks-from-3a377294

I was unable to find several of the Task last exit codes. A good number of them from the following source have been included tough;

  * <http://msdn.microsoft.com/en-us/library/windows/desktop/aa383604(v=vs.85).aspx>

### Downloads

[Download this script from the technet gallery.][2]

 [1]: /2013/09/19/gather-remote-command-results-with-powershell/
 [2]: http://gallery.technet.microsoft.com/Retrieve-Remote-Scheduled-72985b8f