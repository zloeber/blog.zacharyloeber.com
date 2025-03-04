---
title: Exchange Mailbox Auditing with Powershell
author: Zachary Loeber
type: post
date: 2014-11-25T05:55:01+00:00
excerpt: I came up with these Powershell functions due to some of the idiosyncrasies in exchange mailbox permissions and rights delegations.
url: /blog/2014/11/24/exchange-mailbox-auditing-with-powershell/
categories:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - Scripting
  - Windows

---
Some time ago I wrote a script and GUI for performing security audits of Exchange mailbox and calendar rights in an environment. This script was far more popular than I anticipated and, I’m ashamed to say, was rather poorly written by my current Powershell standards. There is an obvious need to simplify the extraction of mailbox permissions or my old script would not still be so popular. So I’ve started to revisit my old code for this project in hopes of remaking it with my PowerShell reporting engine. The first step in this process is to pull out the several bits of code that do the actual rights/permissions extraction. I think I’ve finally got this part done and see no reason not to release this mini-library of functions first.

<!--more-->

I came up with these powershell functions due to some of the idiosyncrasies in exchange mailbox permissions and rights delegations. These functions are broken down as follows:

**Get-MailboxForwardAndRedirectRules** &#8211; Retrieves a list of mailbox rules which forward or redirect email elsewhere. This can be extremely helpful to audit every now and a gain. Users whom have left the organization are fully capable of configuring a rule in Outlook to forward all inbound email to their personal mail account. Little do you realize that mail may be flowing into then right out of your organization.

This function really just wraps up Get-InboxRule and filters out rules that forward, forward as attachment, or Redirects anywhere that isn’t an exchange address (preceded by EX:/) or null. I actually had a less pretty function for this created when I found a decent function from someone else (referenced in script notes) and recreated it to my liking.

**Get-MailboxCalendarDelegates** &#8211; Retrieves a list of user delegated calendar permissions. This is different than calendar permissions in that delegates are really just resource delegates in many cases and respond on behalf of the mailbox owners. This is a permission set by the mailbox owner within Outlook in most cases and can slip under the radar. The function itself is a simple wrapper around Get-CalendarProcessing and returns a prettified list of the resourcedelegates property.

**Get-MailboxExtendedRights** &#8211; Gathers a list of extended rights like &#8216;send-as&#8217; on exchange mailboxes. This is the typical AD rights associated with a mailbox and can be inherited from the database level (or higher) and can also be directly assigned. The function defaults to send-as but you can also get all extended rights by passing \* instead I suppose. I put this together as extended rights are obscurely nestled behind get-adpermission in a non-default property (doesn’t get displayed in output unless using select \*).

So if you wanted to get all the explicitly set rights on mailboxes for send-as you just run the following:

<pre class="lang:powershell decode:true">Get-Mailbox -ResultSize Unlimited | Get-MailboxExtendedRights</pre>

**Get-MailboxSendOnBehalfRights** &#8211; Gathers a list of users with sendonbehalf rights for a mailbox. This is a separate right on mailboxes for whatever reason so it is in a separate function here as well. Like the prior command you can easily get all mailboxes that have other users able to send on behalf of permissions like so:

<pre class="lang:powershell decode:true">Get-Mailbox -ResultSize Unlimited | Get-MailboxSendOnBehalfRights</pre>

<span style="line-height: 1.6;">These particular rights are directly on the mailbox object itself and can be attained with Get-Mailbox. This function simply wraps that cmdlet up and pulls the names buried in the properties of grantsendonbehalfto on the Mailbox.</span>

**Get-MailboxCalendarPermission** &#8211; Get a list of permissions for mailbox calendars in an exchange environment. As different languages spell &#8216;calendar&#8217; differently this script first pulls the actual name of the calendar by using get-mailboxfolderstatistics and has proven to work across multi-lingual organizations. This has recently been updated to work with Office 365 as well, sweet.

**_Get-MailboxPermission_** – Ok, this isn’t my function but rather is baked right into Exchange. You would use this to get full access permissions and most any other permissions you are looking for from Exchange. A permission is not really the same as a right and isn&#8217;t in my little function library.

Most of this stuff isn&#8217;t ground breaking or difficult to get out of Exchange but I thought that a few functions for the most common tasks would make my future code more readable. You can get these functions at the [Microsoft Technet Gallery][1] and my [Github repository][2]. Enjoy!

 [1]: https://gallery.technet.microsoft.com/Exchange-Mailbox-Auditing-00d2e2a8
 [2]: https://github.com/zloeber/Powershell/tree/master/Exchange