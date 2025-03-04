---
title: 'Office 365: Some Scripts'
author: Zachary Loeber
type: post
date: 2016-04-19T21:25:58+00:00
excerpt: Here are three PowerShell Scripts I used in an Exchange Online Hybrid migration.
url: /blog/2016/04/19/office-365-some-scripts/
categories:
  - Exchange 2013
  - Microsoft
  - Office 365
  - Powershell
  - System Administration
tags:
  - Exchange 2013
  - Exchange Online
  - Hybrid
  - o365
  - Office 365
  - Powershell
  - System Administration

---
Hello again world, it sure has been a while since I’ve last written to nameless masses. I’ve got some new scripts to share for those who are interested.

<!--more-->

I’ve accepted a new role within a great organization and it has kept me very occupied. Between VMware upgrades, VPN migrations, and network troubleshooting I’ve been tasked with completing an Exchange 2013 migration then immediately afterwards migrating to Office 365.

So I got hybrid setup, migrated public folders, setup Lync hybrid integration, got ADFS up to snuff, and all the other fun tasks involved with a seamless user experience. It wasn’t until I started looking at getting all the relevant licensing that I realized just how much money one can save if they properly categorize their mailboxes prior to migration. This leads me to the first script I put together.

# Shared Mailboxes

Shared mailboxes server a variety of purposes and can be ‘Shared’ in a few different ways. For our discussion we will assume that shared mailboxes are those which others have been assigned ‘Full Access’ permissions. In the past I’ve released several helper scripts to pull calendar permissions, ‘send as’ permissions, and other delegation/permission information from mailboxes. One which I’ve not released was a full access permission script. So I modified one of my other functions and updated it for just this purpose.

Get-MailboxFullAccessPermission is a function that does exactly what it says. It is really a helper function for some other things I’m going to explain next but it works perfectly fine as a stand-alone script. You can use this to help determine which mailboxes should be converted into ‘shared’ mailboxes prior to your migration. Each shared mailbox does not require a license so this can actually save you quite a bit of money a year if you just spend a little time and analytical efforts to find and convert these mailboxes ahead of your migration.

This script will also automatically expand AD groups if they have been assigned full access permission as well.

## The Script

Get-MailboxFullAccessPermission.ps1 – [On GitHub][1], On [Technet Gallary][2]

> **Note:** Before doing any large migration batches I highly recommend running this function and exporting its results to a CSV file. If any permissions are lost in the migration (which can happen if the groups are not universal groups) then you can very easily reassign the permissions again with a bit of scriptwork.

# Migration Groups

Shared mailboxes are great because they don’t cost you anything to have in o365 but they are a huge pain to deal with in a hybrid scenario. If you don’t move everyone over that has access to the shared mailbox together there can be additional login prompts and headaches for your end users.

Keep in mind that this full access permission issue webs out to other users as well. So if one user has access to a shared mailbox and that user also has an administrative assistant that has full access to his/her mailbox then all mailboxes in that chain of connections needs to be moved at once. This can start to get really complicated quickly if you don’t know what you are looking at. It is also probably why many organizations will just bite the bullet and migrate all accounts over as fast as possible rather than trying to intelligently determine the groups which should be moved over.

If you are going to migrate people to Office 365 in a hybrid scenario, then it would make sense that those you first move over should be standalone mailbox accounts that others don’t have full access to and which are not accessing other mailboxes either.

> **Note:** I’m not including one other area of concern, send on behalf and send as permissions should technically be taken into account as well. I’ve personally converted all send on behalf to send as permissions and ensured that if people are sending as a mailbox that they also have full access to it. That model simplifies things greatly for shared mailboxes as it is also how you treat shared mailboxes on o365 with the simplified management of them in the administrative console.

Using the full access permission script above I added to it to help determine which mailboxes should be migrated together. Run without any seed user the script will list out all of the mailboxes which can likely be migrated at any time without consequence. If you run the script again with a seeduser specified it will use the permissions gathered in the prior run to help answer the question, “if I migrate seeduser right now, what other mailboxes should probably get migrated as well?”.

## The Script

Get-HybridMigrationCandidates.ps1 – [On GitHub][3], On the [Technet Gallery][4]

# Weird Migration Issues and a Small Bonus

I ran into a number of post mailbox migration issues which kicked me in the shins a bit. I created this script to run after any large batch of mailboxes were moved to start trying to help me catch issues before they were reported. It is a quick reporting script that stores 4 globally scoped variables (so maybe not the best coding example to learn from..). But they all use some of the same dataset to get generated so I decided to just put them all in one script.

This is meant to be run from an exchange on premise server and produces the following results in some script variables for further use or processing:

**$RemoteOnlyMailboxes**

All mailboxes which are found in the o365 tenant which are not found locally as &#8216;remote mailboxes&#8217;. These may be on purpose but may also experience issues with autodiscover and cross-premise delivery in a hybrid scenario.

**$AliasMismatches**

Mailboxes in the environment with aliases which don&#8217;t match their primary smtp address. I&#8217;ve personally had issues with RemoteRoutingAddresses being incorrect in these cases. Maybe it was &#8216;just me&#8217; though.

**$MismatchedRemoteMailboxes**

Remote mailboxes with RemoteRoutingAddresses which are not in your current federated domains list. Maybe this is intentional, maybe it isn’t, either way it is kind of good to know.

**$MigrationStatus (Bonus!)**

A list of current remote move requests and their status on the o365 side. This is combined with the mailboxes on premise to try and get a full report of where we are in the migration process. The data can be spit out to excel to make pretty charts for management on your migration status reports 🙂

> **Note:** This script has only been tested with Exchange 2013 in a hybrid configuration.

## The Script

Get-ExchangeOnlineHybridIssueReport.ps1 – [On GitHub][5], On the [Technet Gallery][6]

# Conclusion

Well that is more than enough for one post. I hope others get some use from these little bits of code.

 [1]: https://raw.githubusercontent.com/zloeber/Powershell/master/Exchange/Get-MailboxFullAccessPermission.ps1
 [2]: https://gallery.technet.microsoft.com/Exchange-Get-MailboxFullAcc-34dd1074
 [3]: https://raw.githubusercontent.com/zloeber/Powershell/master/Exchange/Get-HybridMigrationCandidates.ps1
 [4]: https://gallery.technet.microsoft.com/Exchange-o365-Migration-ca91c4d1
 [5]: https://raw.githubusercontent.com/zloeber/Powershell/master/Exchange/Get-ExchangeOnlineHybridIssueReport.ps1
 [6]: https://gallery.technet.microsoft.com/Exchange-Office-365-Hybrid-1b2ce7b7