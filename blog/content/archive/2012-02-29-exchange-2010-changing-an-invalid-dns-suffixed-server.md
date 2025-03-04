---
title: 'Exchange 2010: Changing an invalid DNS suffixed server'
author: Zachary Loeber
type: post
date: 2012-03-01T05:30:13+00:00
excerpt: 'Exchange 2010: Changing an invalidly DNS suffixed server'
url: /blog/2012/02/29/exchange-2010-changing-an-invalid-dns-suffixed-server/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - IIS
  - Microsoft
  - Networking
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
I ran into an interesting Exchange 2010/2007 co-existence issue today. After a new Exchange 2010 (all-in-one) server was introduced into the environment traffic would only flow from the 2010 server to the 2007 hub/cas server and not the other way around. The mail queues stated the last error to be

<pre>“Initial error: 451 4.4.0 dns query failed. The error was: SMTPsend.dns.nonexistentdomain; nonexistent”</pre>

<!--more-->

The general setup was a single site layout with 2 Exchange 2007 servers. One as a hub/cas server and the other as a database server.  The upgrade was for a separate forest in a larger organization but sharing the same root namespace (ie. clientdomain.organization.com but a completely different forest not sharing DCs or other services with organization.com). The new TMG and Exchange 2010 servers were setup by the client before I arrived per my recommendations. For this discussion let’s use the following as our server names:

Exchange 2007 Front-End: Exch2007FE.clientdomain.bigorg.local

Exchange 2007 Mailbox – Exch2007Mail.clientdomain.bigorg.local

New Exchange 2010 server – Exch2010.clientdomain.bigorg.local

I configured the Exch2010.clientdomain.bigorg.local server about 90% and had started replicating public folders to it, or thought I was at least. Being a bit of a pessimist (not about everything, just Exchange deployments), I made sure to check the queues on both the 2007 and 2010 side. Low and behold there were about 500 messages waiting in the “Hub-Version-14” queue on the 2007 server. Bummer….

Now this wouldn’t be so interesting had I not already [manually removed the empty SERVERS container from the First Administrative Group via ADSIEdit][1] in preparation for the public folder migration.  Also there were no other real issues, the domain was clean as could be (after I cleaned it up of course) and the two servers were even on the same subnet.  I also validated that email could be sent from 2010 to the 2007 servers and out the network, just not the other way around. I know that there have been prior issues with Exchange 2007 running on Windows 2008 with IPv6 disabled (as is was the case in this environment) but I couldn’t believe that to be the issue as the environment works in all other aspects except for email being sent to the Exchange 2010 server.

After trying a number of different things I broke down and ran the Exchange BPA on the 2010 server. Surprisingly enough it did come up with a few items but they were warnings that were not immediately visible unless I dug into the results. The warning which peaked my interest was that name resolution did not return a result for _Exch2010.bigorg.local._ Note that the prior DNS name did not at all include the “clientdomain” portion.

I validated that the server was added to the domain properly but for whatever reason, exchange seemed to think that the server should be in just the bigorg.local forest for DNS resolution. As this was an entirely separate forest running under the same namespace as bigorg.local it is highly unlikely that exch2010.bigorg.local would ever resolve properly J. Digging into exch2010 a bit further revealed that the server must have been templated from a VM in the bigorg.local domain as both the new TMG and new Exchange 2010 server had their DNS suffix **_manually set_** to just be bigorg.local. I don’t know why a large organization with several sub-forests would template out their VMs with a manual suffix but they did.

I tried being slick (or cheap) and just changed it to what it was supposed to be locally and rebooted. That not only failed to fix the issue but caused all exchange services to have issues as well(kinda expected it to though). With a deadline to meet, no desire to wait for a new server to be built, and even less of a desire to remove the entire installation and try re-installation on the system I opted to resolve this the hard way. Here is what I did:

1.)    First I started looking for exch2010.bigorg.local all over the place. There are little references to it in any of the files or registry on the server. And this actually makes sense if you think about it. If you run a setup.com /m:recoverserver how would the exchange installer know what roles and names need to actually be recovered on a new server anyway? It would have to gather that information from active directory. So I then popped up ADSIEdit and started looking at the properties of the exch2010 server in the configuration container under:

<pre>CN=EXCH2010,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=OrgName,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=clientdomain,DC=bigorg,DC=local</pre>

In the attributes for the server I found networkaddress had multiple entries, one of which looked like this:

<pre>ncacn_ip_tcp:exch2010.bigcorp.local</pre>

Looking up ncacn\_ip\_tcp brought me [to this article][2] from 7 years ago. I went ahead and removed ncacn\_ip\_tcp:exch2010.bigcorp.local and added ncacn\_ip\_tcp:exch2010.clientdomain.bigorg.local.

After restarting the server again, mail started flowing from the 2007 server to the 2010 server. But now the 2010 exchange management console was broken and all sorts of errors were still occurring from the suffix name change.

2.)    I knew this couldn’t be the only reference to the server FQDN in AD. Almost all the errors seemed to be related to the IIS related services so taking [a hint from this article][3] I started looking at the protocols attributes in ADSIEdit. I found that I needed to change the msExchMetabasePath for all of the EXCH2010 virtual directory protocol objects. I’ll not list them all here but the one for owa looks something like this:

<pre>CN=owa (Default Web Site),CN=HTTP,CN=Protocols,CN=EXCH2010,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=ORGNAME,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=clientdomain,DC=bigorg,DC=local</pre>

3.)    I also needed to change msExchInternalHostName attribute for the powershell virtual directory object in adsiedit:

<pre>CN=PowerShell (Default Web Site),CN=HTTP,CN=Protocols,CN=EXCH2010,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=ORGNAME,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=clientdomain,DC=bigorg,DC=local</pre>

4.)    I updated msExchSmtpFullyQualifiedDomainName on:

<pre>CN=1,CN=SMTP,CN=Protocols,CN=EXCH2010,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=ORGNAME,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=clientdomain,DC=bigorg,DC=local</pre>

5.)    Finally, updated serviceBindingInformation on:

<pre>CN=EXCH2010,CN=Autodiscover,CN=Protocols,CN=EXCH2010,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=ORGNAME,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=clientdomain,DC=bigorg,DC=local</pre>

Doing this and restarting the server cleared up any of the lingering errors that were left over from it’s traumatic dns suffix change. The last thing which was really irritating is that the EMC would still reference the old server name and error out. I knew that it was some user profile setting and [found this site][4] with good directions on fixed this issue. The resolution is simple, delete the MMC cache for EMC and kill a registry key.

1.)     Close EMC

2.)     Delete MMC cache files from C:\users\<username>\AppData\Roaming\Microsoft\MMC\Exchange Management Console\

3.)     Delete NodeStructureSettings in registry from HKCU\Software\Microsoft\Exchangeserver\v14\AdminTools\NodeStructureSettings

There, now everything was right as rain again! Well you will still have to change the autodiscoverinternaluri and do a few other changes, but you can use powershell for that part.

 [1]: http://exchangeserverpro.com/public-folders-not-replicating-between-exchange-2007-and-2010
 [2]: http://technet.microsoft.com/en-us/library/aa997105%28v=exchg.80%29.aspx
 [3]: http://technet.microsoft.com/en-us/library/dd535378%28v=exchg.80%29.aspx
 [4]: http://lyncdup.com/2011/11/exchange-management-console-pointing-to-wrong-server-the-attempt-to-connect-to-httpserver-domain-compowershell-using-kerberos-authentication-failed/