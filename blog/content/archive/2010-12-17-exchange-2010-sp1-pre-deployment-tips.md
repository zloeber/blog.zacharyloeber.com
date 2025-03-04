---
title: 'Exchange 2010 (SP1): Pre-Deployment Tips'
author: Zachary Loeber
type: post
date: 2010-12-17T18:55:00+00:00
excerpt: With an Exchange 2003 to 2010 migration if you are going to do anything other than a single server install and are doing things like, oh say; hardware load balancing, Exchange 2003 co-existence, or working in an old multi-domain forest then you are in for some punishment. Here are some tips to help out.
url: /blog/2010/12/17/exchange-2010-sp1-pre-deployment-tips/
wordbooker_options:
  - 'a:9:{s:18:"wordbook_noncename";s:10:"0fdd5b2a4f";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";}'
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
  - Windows

---
I recently had the opportunity to experience all of the blood, sweat, and tears of migrating a minimally maintained Exchange 2003 infrastructure to Exchange 2010 (and mid-way through, an upgrade to 2010 SP1). All of the docs out on the web for migrations make it seem soooo easy. But if you are going to do anything other than a single server install and are doing things like, oh say; hardware load balancing, Exchange 2003 co-existence, or working in an old multi-domain forest then you are in for some punishment. I think I ran into every possible issue that you can have with an Exchange 2010 migration. One guide that helped me in this endeavor was the <a title="Rapid Exchange 2003 to 2010 Transition Guide" href="http://msexchangegeek.com/2010/01/30/rapid-transition-guide-from-exchange-2003-to-exchange-2010/" target="_blank">rapid transition guide from Exchange 2003 to Exchange 2010</a>. This guide didn&#8217;t cover every aspect for me though, here are a few things that may save you a little bit of hassle. I&#8217;ve been meaning to publish this for a while and I have a whole lot more notes from this experience but this is a start.

## <!--more-->

**1.)    Ensure all Exchange servers have the right local administrators and are in the right active directory exchange groups.**

Here are the AD security groups I would ensure that both your exchange 2003 and exchange 2010 servers are in:

&#8211;          <Forest root>\Exchange Trusted Subsystem

&#8211;          <Forest root>\Exchange Servers

&#8211;          <Domain root>\Exchange Domain Servers

&#8211;          <Domain root>\Exchange Install Domain Servers

Here are the AD security groups I would ensure are local admins on your exchange 2003 and 2010 servers:

&#8211;          <Forest root>\Exchange Trusted Subsystem

&#8211;          <Forest root>\Organization Management

&#8211;          <Domain root>\Exchange Domain Servers

&#8211;          <Domain root>\Exchange Enterprise Servers

&#8211;          <Domain root>\Exchange Servers

Exchange Trusted Subsystem is going to be your #1 group to look for in ensuring exchange interoperability between your old 2003 servers and your shiny new Exchange 2010 servers. If you are not doing your own schema prep (aka, you are not the schema admin/enterprise admin) then triple check that replication between the domain  you are upgrading to 2010 and those that are remaining as legacy 2003 servers are replicating properly. Even if your local domain shows that an exchange 2003 server in another domain is in the “Exchange Trusted Subsystem” group does not mean that it actually is from the remote domain’s viewpoint if replication is going awry.

## **2.)    Don’t remove ExchangeSetupLogs Directory**

I made the mistake of doing this and then when I had to reinstall a component ran into all kinds of issues. It isn’t that large of a directory so just leave it alone and you will be cool. As I mentioned before, you will break your powershell virtual directory if you remove then re-add components. Adding to that, if you experience any errors at all in  your install but everything still seems to be working don’t expect to be able to reinstall components without hacking the registry to trick out the installer. You will get to a point in the component reinstallation where it will whine about a previous install going awry, you will then remove the registry settings which it is reading these settings from, then you go to install the components again and the installer will think a reboot is needed from running the prior time. I must have rebooted 20 times for one server that was misbehaving when trying to repair a component (I’m nothing if not persistent)

## **3.)    Never Assume a Wizard will “Just Work”**

Ok, this isn’t really exchange specific but it is worth mentioning given all the moving parts and ancillary required infrastructure for truly redundant exchange 2010 architecture.

I made the assumption that the F5 exchange 2010 CAS load balancing wizard would work out of the box. I also made the assumption that the UAG 2010 Exchange 2010 wizard would work without modification. Neither did and I found myself scratching my head.

For these particular puzzle pieces of your Exchange 2010 architecture make sure to get the most recent deployment documentation from your load balancing vendor as well as Microsoft and read through it studiously. For the F5 portion of things even the initial documentation was flawed and the iRule provided for a single pool setup was flat out wrong. I had to hack a workable irule together until a new revision was released with an updated iRule. For UAG, the wizard gives you options to deploy web services, autodiscover, outlook anywhere, and activesync all at once. Unfortunately you simply cannot deploy a working solution this way. You need to run through the wizard multiple times (at the bare minimum twice) and deploy each component in a different way.

## **4.)    Don’t mess with the IPv6 settings**

Perhaps most of my issues are a result of adamantly refusing to use non-R2 Windows 2008 servers. Maybe, this particular issue would not have been experienced on a standard 2008 server instance but regardless, I had a hell of a time with IPv6. I initially thought I’d be clever and assign static IPs to my DC’s and do the same on the exchange servers. This was a technically correct way to approach this issue as I had read not to disable IPv6 on exchange 2010. But this seemed to cause performance issues with the exchange servers as I didn’t have an entire domain site structure setup for any IPv6 subnets. So they were getting sub-optimal DCs for GAL lookups. I had to go back to automatically configured IPv6 addresses and that seemed to make the CAS servers happy.

At one point I disabled IPv6 for the database servers as well (maybe I temporarily lost my mind). NEVER ever disable IPv6 from an already deployed server which included it. When I did remove IPv6 settings it caused the server to hang at boot and/or shutdown and caused all kinds of headaches. Just leave the settings as they are by default and Exchange 2010 is happy as a clam. There are ways to completely remove IPv6 from a windows 2008 R2 server but I’d rather just disable IPv6 on my core routers and leave it enabled on the server. This way, should I decide to round back and implement an internal IPv6 infrastructure, I don’t have to undo the IPv6 removal on a bunch of servers.

## **5.)    Get Powerful with Powershell**

I’m pretty certain that I would not be able to have completed the amount of work I did with the Exchange Management Console alone. In fact I’m positive that I would not have been able to do so as some tasks simply cannot be done except via powershell. Here is a small list of such tasks.

_Adding additional routing groups:_

<pre style="padding-left: 30px;">New-RoutingGroupConnector -Name "RG Exchange 2003" -SourceTransportServers "labexch1.corp.contoso.com","labexch2.corp.contoso.com" -TargetTransportServers "exchexclus.corp.contoso.com" -Cost 10 -Bidirectional $true -PublicFolderReferralsEnabled $true</pre>

_Allow thumbnail photos_

<p style="padding-left: 30px;">
  1.       For the photo to be available offline we need to change the thumbnailPhoto from an Indicator to a Value attribute.
</p>

<p style="padding-left: 30px;">
  a.       Remove the Indicator:
</p>

<pre style="padding-left: 30px;">$attributes = (Get-OfflineAddressBook "Default Offline Address Book").ConfiguredAttributes</pre>

<pre style="padding-left: 30px;">$attributes.Remove("thumbnailphoto,Indicator")</pre>

<pre style="padding-left: 30px;">Set-OfflineAddressBook "Default Offline Address Book" -ConfiguredAttributes $attributes</pre>

<p style="padding-left: 30px;">
  b.      Add the thumbnailPhoto property as a Value:
</p>

<pre style="padding-left: 30px;">$attributes = (Get-OfflineAddressBook "Default Offline Address Book").ConfiguredAttributes</pre>

<pre style="padding-left: 30px;">$attributes.Add("thumbnailphoto,Value")</pre>

<pre style="padding-left: 30px;">Set-OfflineAddressBook "Default Offline Address Book" -ConfiguredAttributes $attributes</pre>

_To have a mailbox be audited_

<pre style="padding-left: 30px;">set-mailbox end.user -AuditEnabled $true</pre>

_Enable Client E-mail Read Tracking_

<pre style="padding-left: 30px;">Set-OrganizationConfig –ReadTrackingEnabled $true</pre>

&nbsp;

## 6.)    Get Some Registry Love Too…

Ok, Powershell is not the whole answer to your Exchange 2010 woes. You may need to do some reg hacks as well. I had to do this to enable OWA password reset ability. Save the following to a .reg file and execute on your CAS servers.

<pre>Windows Registry Editor Version 5.00</pre>

<pre>[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSExchange OWA]</pre>

<pre>"ChangeExpiredPasswordEnabled"=dword:00000001</pre>

## 7.)    Don’t Believe Limits

Well maybe this is me just being a bit snarky about one issue I ran into where people couldn’t upload attachments over 5mb after being migrated to Exchange 2010. But there are about three different places where you can set limits for e-mail size for an end user and all of them were over 5mb in my environment. I read a bit further into this and found out that “unlimited” actually means 5mb (huh?). Yup, the transport max send size was set to unlimited but until I manually changed it, nothing over 5mb would be accepted.

Change attachment upload limit in OWA from 5mb to 20mb

set-TransportConfig -MaxSendSize:20Mb

## 8.)    Multisite Database Availability Groups Require Some Love

I already wrote up a quick guide to managing maintenance work on your Exchange 2010 DAG which you can read about in one of my prior entries. You also want to periodically check and see that your DAG replica database log indexes are not out of whack (with the commands later on in the post mentioned above).

Another issue I ran into was that the failover cluster services, which are automatically setup when creating a DAG, may have issues you are not even aware of. For me it was a known issue on pre-SP1 installs that was not retroactively resolved when upgrading to SP1. This issue manifests itself as cluster failover errors in the event log and the general inability to run DAG aware backup solutions. I had to go into each network in the failover manager and disable, apply, then re-enable and apply the network public availability checkbox.

I also noticed that in my multisite DAG that the failover clustering was set automatically to allow either site servers to own the IP address of the DAG. This is fine if you are stretching VLANs I suppose, but I am not. So I unchecked the availability to own IP addresses on each network resource for servers that do not have that network available. The setting in failover cluster administration is specifically in the advanced policies of each network IP resource.

<div id="attachment_307" style="width: 414px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2010/12/Exchange_DAG1.jpg"><img class="size-full wp-image-307" title="Failover Cluster Setting" src="/wp-content/uploads/2010/12/Exchange_DAG1.jpg?resize=404%2C549" alt="Failover Cluster Setting" width="404" height="549" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Failover Cluster Setting
  </p>
</div>

&nbsp;

&nbsp;

Finally, you may want to increase the cross-subnet delay to reduce unnecessary DAG failovers on tenuous WAN links between your sites. This is actually done with a basic administrative cmd.exe prompt and a cluster.exe command:

cluster /cluster:exchdag1 /prop CrossSubnetDelay=2000

## 9.) Make Sure Your Time is Synced for Edge Servers

If the time is off between your internal and your edge servers then the one way sync and other operations may start to fail or experience delays. I opted to have the edge servers sync with my internal servers and open the ntp port to allow them to do so through the firewall.

Set NTP for Edge Servers

<pre>import-module ServerManager</pre>

<pre>w32tm /config /manualpeerlist:"x.x.x.x y.y.y.y"</pre>

<pre>net stop w32time</pre>

<pre>net start w32time</pre>

<pre>set-service w32time -startuptype Automatic</pre>

## 10.) Do Not Assume Permissions

When I started migrating user mailboxes I started getting errors like the following for some accounts:

Active Directory operation failed on your.domain.controller. This error is not retriable. Additional information: Insufficient access rights to perform the operation.

Active directory response: 00002098: SecErr: DSID-03150BB9, problem 4003 (INSUFF\_ACCESS\_RIGHTS), data 0

+ CategoryInfo          : NotSpecified: (0:Int32) [New-MoveRequest], ADOperationException

+ FullyQualifiedErrorId : B959FFD3,Microsoft.Exchange.Management.RecipientTasks.NewMoveRequest

All this meant was that permissions for the user in AD was not set to inherit for whatever reason. So I had to right-click on the account in ADUC, go to properties, select permissions (only viewable if you select the advanced option in the view menu of ADUC btw), then go to advanced, and select the inherit checkbox option. After this was done I was instantly able to migrate the mailbox.

## 11.) Microsoft Has Gotten A Bit More Stringent With Things

What this means is that your distribution lists, email accounts, and email enabled groups may just work out of the box… as long as they do not have any spaces or strange characters in their alias field and are universal. From 2003 to 2010 is a long time in the IT world, and stuff has changed. Time to update a few things to work. Aliases  with spaces may work but will exhibit issues (like the inability to be updated).

_First update your email enabled groups to be universal_

<pre style="padding-left: 30px;">Get-Group  | Where {$_.GroupType -Like "Global*"  -AND $_.RecipientType -eq "MailNonUniversalGroup"} | Set-Group –Universal</pre>

_Fix up any distribution lists with bad aliases_

<pre style="padding-left: 30px;">foreach ($dl in Get-DistributionGroup)</pre>

<pre style="padding-left: 30px;">{</pre>

<pre style="padding-left: 30px;">[regex]$pattern = "[\s\(\)]"</pre>

<pre style="padding-left: 30px;">$email = $dl.PrimarySmtpAddress.local</pre>

<pre style="padding-left: 30px;">$name = $dl.Name</pre>

<pre style="padding-left: 30px;">$displayname = $dl.DisplayName</pre>

<pre style="padding-left: 30px;">$samaccountname = $dl.samaccountname</pre>

<pre style="padding-left: 30px;">$alias = $dl.Alias -replace $pattern</pre>

<pre style="padding-left: 30px;">if ($email -ne $alias)</pre>

<pre style="padding-left: 30px;">{</pre>

<pre style="padding-left: 30px;">write-host "Applying settings for NONMATCHING DL:, $displayname, $name, $samaccountname, $alias, $email" -foreground "blue"</pre>

<pre style="padding-left: 30px;">Set-DistributionGroup $samaccountname -name $name.Trim() -alias $email -DisplayName $displayname.Trim()</pre>

<pre style="padding-left: 30px;">}</pre>

<pre style="padding-left: 30px;">else</pre>

<pre style="padding-left: 30px;">{</pre>

<pre style="padding-left: 30px;">write-host "Applying settings for:, $displayname, $name, $samaccountname, $alias, $email" -foreground "green"</pre>

<pre style="padding-left: 30px;">Set-DistributionGroup $samaccountname -name $name.Trim() -alias $email -DisplayName $displayname.Trim()</pre>

<pre style="padding-left: 30px;">}</pre>

<pre style="padding-left: 30px;">}</pre>

_Remove Spaces From Mailbox Aliases_

<pre style="padding-left: 30px;">Get-Mailbox -ResultSize Unlimited | Where {$_.Alias -match '\s+'} | ForEach-Object {Set-Mailbox $_.Name -Alias:($_.Alias -Replace " ","")}</pre>

<pre style="padding-left: 30px;">Get-Mailbox -ResultSize Unlimited | Where {$_.Alias -like '* '} | ForEach-Object {Set-Mailbox $_.Name -Alias:($_.Alias -Replace " ","")}</pre>

&nbsp;

## 12.) Don’t Forget To Review Existing Dynamic Distribution Groups Prior to Migrating Any Mailboxes

Sounds kinda silly when I’m writing this stuff sometimes, but this is absolutely true. The dynamic distribution groups you may have known with your beloved ldap filters (you know… the stuff you have always used with dsquery.exe and other old school cmd.exe tools) have now changed to opath filters. Opath filters are what powershell uses so that is what exchange will use.

Furthermore, if you were not the prior dynamic distribution group creator then you may not realize that the dynamic distro groups were created in weird and non-forward moving ways. In my case there were groups that referenced specific servers and were wildly off-base for the target audiences for which they were designed. Most companies rely on these groups for mass emails to their valued employees. Before you start migrating your users do yourself a favor and revisit the current dynamic distribution groups and recreate them as needed to be something worthy to be inherited by your next Exchange admin.

## 13.) Be Careful With Migration of Direct Booking Resources

If you are upgrading from Exchange 2003 to 2010 then you need to convert your resource groups in a special way for them to work properly.

In the Exchange 2003 direct booking resource mailbox, perform the following steps in outlook:
  
1. From the Tools menu, click Options.
  
2. In Options, click Calendar Options.
  
3. In Calendar Options, click Resource Scheduling.
  
4. In Resource Scheduling, clear the Automatically accept meeting requests and process cancellations check box.
  
5. Click Set Permissions, click the Permissions tab, and then change the Default permission from Author to None. This action prevents users from logging on to the mailbox directly. You can set the Default permission to Reviewer if you want to allow users to view the full details of meetings that are scheduled for the resource.

Use the Exchange Management Shell or the Exchange Management Console to move the direct booking resource mailboxes from the Exchange 2003 server to an Exchange 2010 mailbox server.

Convert to a room that auto-accepts:

Set-Mailbox -Identity &#8220;mailbox name&#8221; -Type RoomSet-CalendarProcessing
  
&#8220;mailbox name&#8221; -AutomateProcessing AutoAccept

## Bonus Tip: The outlook address book is really slow to update

Really slow… snail paced slow, honestly. As a basic reference keep in mind that Outlook takes approximately 24 hours to do a full offline address book download if Outlook is running continuously.

So if updating distribution group permissions (adding sendas permissions for example) do a full download of the address book in outlook clients running in cached mode. This also holds true for uploaded photo’s in the GAL for users. If someone asks me how long a photo will take to show up in Outlook 2010 I have learned to say “at least 3 days” and so should you. But if you want instant gratification you can manually update your OAB then have your users all manually download their address books. But that’s crazy talk. 🙂

&nbsp;

&nbsp;