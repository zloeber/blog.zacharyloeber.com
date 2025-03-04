---
title: 'Active Directory: Best Practices Workbook'
author: Zachary Loeber
type: post
date: 2012-05-28T21:57:58+00:00
excerpt: This is a checklist for technicians performing Active Directory assessments. It is broken down by category and best practice. Some items listed are not really a best practice, but rather something which you may find in an environment which should be rectified (as part of an audit perhaps).
url: /blog/2012/05/28/active-directory-best-practices-workbook/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - Microsoft
  - Networking
  - System Administration
tags:
  - Active Directory
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
  - Windows

---
This is a checklist for technicians performing Active Directory assessments. It is broken down by category and best practice. Some items listed are not really a best practice, but rather something which you may find in an environment which should be rectified (as part of an audit perhaps).

<!--more-->

This is actually part of a comprehensive template I’m working on for clients of my company but minus the pretty report, technical references, and the matching scripts/procedures to gather all the required information to determine if these best practices are being followed. Starting this list on my own time stemmed from multiple discussions I’ve found myself in regarding best practice (for AD, Exchange, VMware, server builds, et cetera). I recognize that all IT environments are different and that things change faster than a newborn’s diapers. Regardless, I believe that a general set of best practices for any non-emergent technology can be 90-95% agreed upon.

Active directory in a Windows heavy infrastructure is certainly non-emergent. The first real version of the LDAP based database goes back over a decade to Windows 2000. In 2003 the upgrade to Windows 2003 fixed many of the shortcomings of the original release of the OS as well as the AD service (like XP did for windows ME) and a good many companies are still at this version. Active directory is also one of the areas of a client’s infrastructure which constantly causes no end of issues in other business related and tightly integrated technologies (ie. Exchange, Sharepoint, Lync, et cetera). Thus it is good to review these things every now and again so the next Exchange upgrade or Lync implementation you want to perform is not waylaid by AD infrastructure issues…\*hint\* \*hint\*

I’ve put together a list of general best practices I’ve experienced and come across through the years and through other professionals&#8217; ranting/informational posts on the web. Later on I may release some of the powershell code I use to gather AD info from an environment. Until then, all the methods to determine if an AD implementation follows the best practices listed are easily attained via a quick web search.

Some of the “best practices” listed were hard to nail down (in particular local nic DNS settings) so I went with personal experience as a tie breaker in these cases. I also took information liberally from some outside sources in coming up with this list (in my deliverable report I only include Microsoft references though). A list of some of these sites and a kudos to their authors:

[Rob Silver recently posted a great article with a really nice list of AD site best practices][1].

[Andy Wolf posts an example of what Microsoft looks for in their Risk Assessment Program for AD.][2]

[8 AD Mistakes You May Have Missed][3]

[Windows 2003 DNS Best Practices][4]

Here is the workbook itself, hope it proves to be of some value to the community:

**[AD Best Practices Workbook][5]**

 [1]: http://robsilver.org/2012/04/07/active-directory-sites-best-practices/
 [2]: http://andywolf.com/microsoft-risk-assessment-program-for-active-directory
 [3]: http://redmondmag.com/articles/2007/01/01/8-ad-mistakes-you-may-have-missed.aspx
 [4]: http://networkadminkb.com/KB/a4/windows-2003-dns-best-practices.aspx
 [5]: /wp-content/uploads/2012/05/AD-Best-Practices-Table.docx