---
title: Exchange 2010 Mailbox Audit Report Script
author: Zachary Loeber
type: post
date: 2013-05-10T02:33:54+00:00
excerpt: Retrieves a list of various mailbox permissions and other settings one might use in an audit to determine where email may be leaking out of the organization or where there may be security risks.
url: /blog/2013/05/09/exchange-2010-mailbox-audit-report-script/
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Microsoft
  - network administration
  - Powershell
  - Security
  - Sysadmin
  - System Administration
  - Windows

---
# Exchange 2010 Mailbox Audit Report Script

Recently I’ve released a number of scripts such as the [HTML Table Colorizer][1], [Exchange Mailbox Calendar Permission Function][2], and the [Exchange Mailbox GUI][3]. These were all actually created specifically as support scripts for a report generation powershell tool I’ve been working on, the Exchange Mailbox Auditing Tool.

<!--more-->

# About

The idea from this script came from experience working in multiple exchange organizations which have evolved over the years with different admins, support staff, and Exchange versions. By the time an upgrade to Exchange 2010 is in order some of these email environments may be technically functional but with a ton of “cruft” on the backend which may not be readily visible.

I like to view this kind of accumulated cruft as analogous to a file server which has just been migrated from server to server with the same built up permissions and shares that may have been in place since the NT days. Usually they get migrated like this to just keep things working. And this is not bad, but when it comes time to standardize permission groups and eliminate shares it feels like trying to weed an overgrown lawn.

Exchange is the same way, over the years permissions get granted, rules get set on mailboxes, and in general time just happens. In the end you may have thousands of users with calendars allowing anonymous reviewer permissions (mix this with federated domains and things can get weird…). You may also have disabled accounts with mailboxes forwarding email out of the domain, or VIP users with mailboxes that have full access, send as, or send on behalf permissions given to users which shouldn’t have them. If you read this far you get the picture.

I wanted  a few things in a tool like this, I wanted a pretty report that I could customize. It had to include an optional summary (which duals as a quick and dirty mailbox total and mailbox deleted total report with warn and alert color coded cells). I also had to be able to filter out all the known accounts. So if I wanted to cleanse a whole organization I would start with a basic report that excludes known exchange and default accounts then be able to see only the mailboxes which produce results. Then you can start working backwards adding accounts to be ignored if they are valid to have the access they are found to have.  Run the report again, rinse and repeat the process until zero results come up in a generated report.

I really only meant this to be for full permissions to a mailbox at first. I added in more and more sub reports as I thought about it until this script was born. All sub reports are optional. This means you can create just a calendar permissions report for example. Or generate just the summary report for that matter. I’ve not tested every scenario yet but the code is fairly standardized so I’m hoping all the weird ways which this script may be used to generate reports work. Let me know if there is some really cool option I may have missed or a feature which would be beneficial.

## Version

Version         :   1.0.0 May 9th 2013
  
&#8211; First release

# Features

Some of the features of this audit script include:

## Multiple Reports



  * Mailbox full access permissions
  * Mailbox send as permissions
  * Mailbox send on behalf permissions
  * Mailbox calendar permissions
  * Mailbox forwarding rules
  * Mailbox redirecting rules
  * Mailbox summary reports with the following properties 
      1. Last Logon
      2. Last Logon Account
      3. Primary SMTP
      4. Server
      5. Database
      6. Total Size (MB)
      7. Total Items
      8. Total Deleted Size (MB)
      9. Single Item Recovery
     10. Litigation Hold
     11. Retention Hold
     12. Audit Enabled

## Features

All reports can be color coded any number of ways to meet your mailbox auditing report generation needs. You can optionally do the following as well:

  * Report only on non-inherited permissions
  * Include both a mailbox summary report with links to detailed sub-reports
  * Generate just an email summary report
  * Filter out specific users from permissions reports (Accounts such as besadmin or other legitimate access to mailboxes which may trigger false alarms.)
  * Filter out unknown users from permissions reports

This script supports the following scopes of mailboxes:

  * The entire exchange organization
  * A single DAG
  * A single server
  * A single database
  * An arbitrary array of exchange mailboxes names

## Notes

Due to the huge number of function parameters (20+) I’ve not included many examples in the function help as of yet. So here are a few general logic rules to be cognizant of:

  * If you want to just generate a mailbox size report use the following options:

<pre style="padding-left: 30px;">-SendAsPermReport $false –FullPermReport $false –CalendarPermReport $false –ForwardingToReport $false –MailboxRuleForwardingReport $false –MailboxRuleRedirectingReport $false</pre>

  * The IgnoredUsersPermissions parameter is not case sensitive but it does require precise user domain/name formatting to filter properly.
  * If you want to modify any of the report look/feel elements the $ReportStyle variable will be your first stop (I tried to use valid CSS as much as possible).
  * There are no “required” parameters. As such, here is the order of operations for which mailboxes get processed based on parameter (You can specify them all but only the first one in the list with a value will be processed)

>   1. Mailboxes
>   2. DatabaseName
>   3. ServerName
>   4. DAGName
>   5. WholeEnterprise

So if you send through both the DAGName and the ServerName parameter, only mailboxes on the ServerName will be processed. If you pass all parameters listed above only the Mailboxes parameter will matter. Get the drift?

## Conclusion

I’ve pulled from several sources in these scripts I use. I try to leave most of the comments and other original author markings unmolested. If you are an author I’ve not given proper credit or which wants more credit for their work, just let me know and it will be done. Oh I also have a mostly completed GUI for this script in the works which should be released shortly as well…

[Download the script at the Technet Gallery.][4]

&nbsp;

 [1]: http://gallery.technet.microsoft.com/Colorize-HTML-Table-Cells-2ea63acd
 [2]: http://gallery.technet.microsoft.com/Get-Exchange-Calendar-5bb4f527
 [3]: http://gallery.technet.microsoft.com/Exchange-Mailbox-GUI-5b204590
 [4]: http://gallery.technet.microsoft.com/Exchange-Mailbox-Audit-1f56c9a9 "Mailbox Audit Report at Technet Gallery"