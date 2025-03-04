---
title: 'Powershell: Login As Batch Job Security Rights'
author: Zachary Loeber
type: post
date: 2015-07-18T04:09:12+00:00
url: /blog/2015/07/17/powershell-login-as-batch-job-security-rights/
categories:
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Microsoft
  - network administration
  - Powershell
  - PSC
  - Scripting
  - System Administration
  - Windows

---
Here is a quick bit of PowerShell. It is some snippets of C# code wrapped up with PowerShell which will allow you to assign accounts to the &#8216;login as batch job&#8217; local security rights of a local machine. The code is no great shakes but it is a good example of how you might take some existing online code and modify to suit your needs in PowerShell. This function also compliments another script I&#8217;ve released in the past for automatically scheduling PowerShell scheduled tasks rather well.

I&#8217;ve uploaded this code to the [Technet Gallery][1] and [Github][2]. The prior mentioned scheduled task function is also in my [Github repo][3] for your convenience.

 [1]: https://gallery.technet.microsoft.com/Powershell-Add-User-to-fcf4adff
 [2]: https://github.com/zloeber/Powershell/blob/master/Supplemental/Add-UserToLoginAsBatch.ps1
 [3]: https://github.com/zloeber/Powershell/blob/master/Supplemental/New-ScheduledPowershellTask.ps1