---
title: Assessing Like A Microsoft Technician
author: Zachary Loeber
type: post
date: 2012-03-10T03:08:26+00:00
excerpt: Here is a list of site assessment tools I’m finding that I regularly return to for rapid analysis or information gathering at a site. All of these tools are free.
url: /blog/2012/03/09/assessing-like-a-microsoft-technician/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration

---
# Troubleshooting Like A Microsoft Technician

I have been doing more and more site assessments for Active Directory, Exchange, Lync, and VMware. As such, I’ve been slowly refining the toolset that I use to gather data and troubleshoot existing environment issues. Here is a list of site assessment tools I’m finding that I regularly return to for rapid analysis or information gathering at a site. All of these tools are free.

<!--more-->

I should probably state that if you don’t know the concepts and best practices around a technology then any tool used on it loses much of its purpose. After all, a hammer in the hands of a skilled carpenter may be used to build a house whereas that same hammer in the hands of a baboon may be used bust open a skull.

## Windows Environment Utilities

### Active Directory Risk And Health Assessment (ADRAP) – Scoping Tool

This scoping tool is used by Microsoft engineers prior to having a live engineer assess an environment. Any errors which crop up could help forewarn of future issues you may have during your assessment. It also produces a nice HTML formatted table of all DCs in a particular forest (with GC status and FSMO roles) for your deliverable report.

[Download ADRAP – Scoping Tool Here][1]

### MS Product Support Reports (MPS)

This is what a Microsoft technician may have you run to collect comprehensive information about your environment if you were to call their support hotline. The MPS tool is actually a large list of customized VBScript, powershell, and utility binaries which you can use for yourself if you know where to find them. Basically start the program up then look for its temporary file location [as described here][2]. Then copy it elsewhere to keep for yourself! I keep a copy of both the 32 and 64 bit toolkit with me.

One of the tools in this kit I use regularly is the Exchdump.exe binary. Using this with the /ALL switch will generate a pretty lengthily report of many aspects of an exchange 2003/2007 environment with notes of possible issues.  (Also, ExchInfo.vbs can be used for just Exchange 2000/2003 environments).

If you are feeling frisky and want to hack at some powershell aspects of MPS explore the numerous weirdly named folders under  tools/packages (ie. C:\temp\mpsreports\tools\packages\A5ECA148-20AD-4ed5-AF77-9AAA72350884\)

Some of interest to you might be:

A5ECA148-20AD-4ed5-AF77-9AAA72350884 – GetDirectoryServiceInfo.ps1

18A69DCA-3560-42bd-908C-5EC9C9D87209 – GetExchangeInfo.ps1

[Download MPS Reports Here][3]

### MS Product Support Reports Viewer

This is what a Microsoft technician may use to analyze the results of the previously run MPS utility. I’ve not had 100% success rate utilizing them both together, but when they do work together the results are pretty nice. You get color coded logs of several of the information gathering scripts included in MPS.  If I have limited access to an environment or am working on a workstation related issue I may have someone run the MPS utility and upload the resulting CAB file to me. I’ve also gotten into the habit of simply running the MPS utility and saving the resulting CAB for any other assessment I do (in case it is able to quickly find some issue that I was unable to locate)

[Download MPS Reports Viewer Here][4]

### Microsoft Assessment And Planning (MAP) Toolkit

The MAP Toolkit can do many things. Here is the description as stated on the MAP Toolkit homepage:

“The Microsoft Assessment and Planning (MAP) Toolkit is an agentless inventory, assessment, and reporting tool that can securely assess IT environments for various platform migrations—including Windows 7, Office 2010 and 365, Windows Server 2008 R2, Hyper-V, Windows Azure, and Microsoft Private Cloud Fast Track”

What that doesn’t state is that MAP can collect AD and Exchange information and generate nice excel output with connected devices. The MAP Toolkit is the Microsoft version of the VMware Capacity Analyzer tool but for more than just planning out virtualization road maps.

[Download MAP Toolkit here][5]

### Fixit Center Pro (Beta)

Looks like this has been discontinued..

<del>Microsoft provides a beta service for collecting data about an environment and can automatically analyze and offer resolution recommendations on several key product offerings. This free service is called Fixit Center Pro (beta) and can be accessed with your Live ID <a href="https://wc.ficp.support.microsoft.com/Dashboards/Main/SelfHelpCase/Create?showReturn=True">at this website.</a></del>

<del>Some of the Analysis packages you can run in Fixit Center Pro include:</del>

  * <del>Directory Services – Windows 7 and Server 2008 R2</del>
  * <del>Hyper-V – Windows Server 2008 R2</del>
  * <del>Exchange Server 2007 SP3 and Exchange Server 2010 Troubleshooter for Windows 2008 R2</del>
  * <del>Lync Server 2010 Diagnostics Package for Windows 2008 R2</del>
  * <del>Lync 2010 and Microsoft Office Communicator 2007 R2 Basic Diagnostics Package</del>
  * <del>Performance &#8211; Windows 7 and Server 2008 R2</del>

<del>There are also some basic issue-tracking features in the “Work Items” area that you can store notes and links that pertain to current issues you might be researching. If you are not organizing your notes in one of the several great options at your disposal (I’m kind of a OneNote/Tomboy fan myself) then you can use this to give you a quick and easy scratchpad area to track some of those nagging issues you may end up researching.</del>

<del>This site is a bit new to me so I don’t have as much information on its effectiveness as I’d like. The first site I had it analyze I also knew to be “clean” and it did say as much.</del>

<del><a href="https://wc.ficp.support.microsoft.com/Dashboards/Main/SelfHelpCase/Create?showReturn=True">Access Fixit Center Pro (Beta) Here</a></del>

## Conclusion

This is far from being the end-all of my list of tools I utilize on a regular basis. I’ve not even mentioned any of the custom (or public) scripts I’ve come to rely upon. Nor have I discussed what common issues to look for in Exchange/AD.  Coming soon will be my list of tools utilized for VMWare assessments.

 [1]: http://www.microsoft.com/download/en/details.aspx?id=19464
 [2]: http://www.verboon.info/index.php/2011/07/get-the-latest-version-of-the-gpotool-exe/
 [3]: http://www.microsoft.com/download/en/details.aspx?id=24745
 [4]: http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=18325
 [5]: http://technet.microsoft.com/en-us/solutionaccelerators/dd537566