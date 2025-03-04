---
title: 'Exchange 2010: Even More Migration Tips'
author: Zachary Loeber
type: post
date: 2012-07-11T00:34:32+00:00
excerpt: It has been a while since I passed on some personal experiences when performing Exchange 2010 migrations. I thought it was about time to update my list to include some more of the lesser known aspects of an Exchange 2010 migration.
url: /blog/2012/07/10/exchange-2010-even-more-migration-tips/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - IIS
  - Microsoft
  - Powershell
  - System Administration
tags:
  - 2008 R2
  - Active Directory
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
  - Windows

---
It has been a while since I passed on some personal experiences when performing Exchange 2010 migrations. I thought it was about time to update my list to include some more of the lesser known aspects of an Exchange 2010 migration.

<!--more-->

# Tip #1: External autodiscover on TMG requires one extra step

When creating your TMG reverse proxy rules you are never given an option for autodiscover.

<div id="attachment_572" style="width: 160px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/07/TMG-Autodiscover1.jpg"><img class="size-thumbnail wp-image-572" title="TMG-Autodiscover" src="/wp-content/uploads/2012/07/TMG-Autodiscover1.jpg?resize=150%2C150" alt="" width="150" height="150" srcset="/wp-content/uploads/2012/07/TMG-Autodiscover1.jpg?resize=150%2C150 150w, /wp-content/uploads/2012/07/TMG-Autodiscover1.jpg?zoom=2&resize=150%2C150 300w, /wp-content/uploads/2012/07/TMG-Autodiscover1.jpg?zoom=3&resize=150%2C150 450w" sizes="(max-width: 150px) 100vw, 150px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    TMG Autodiscover
  </p>
</div>

That is because it is rolled up with the Outlook Anywhere publishing rule. When you are done creating this rule you will need to manually add autodiscover.yourcompany.com as a listening public name under the “Public Name” of the tab.

# Tip #2: Exchange 2010/2007 coexistence is irritating

That is a bit harsh of me, coexistence it isn’t really irritating but the documentation can be misleading. Let’s start with OWA. If you read [the technet article concerning proxying and redirection][1] for client access it clearly lays out what and end user will experience when logging into OWA on Exchange 2010 when their mailbox is still on Exchange 2007. Here it is, straight from Microsoft. (Note: This is for a same site coexistence scenario only, in a multisite scenario where one site is not internet facing we can utilize full OWA proxying from 2010 to 2007 instead)

> If the user&#8217;s mailbox is on an Exchange 2007 mailbox server, CAS-01 locates a Client Access server in the same Active Directory site as the user&#8217;s mailbox server. If the Exchange 2007 Mailbox server is in the same Active Directory site as CAS-01, one of four possible actions will result.
> 
>   * CAS-01 will look for an Exchange 2007 **ExternalURL** property that has an _ExternalAuthenticationMethods_ setting that&#8217;s identical to the _InternalAuthenticationMethods_ setting on the Exchange 2010 Client Access server. If the settings match, CAS-01 will redirect to this external URL. If source and target CAS have Forms Based Authentication (FBA) enabled, the source CAS issues a hidden form back to the browser that contains the user’s credentials and FBA settings, along with the redirect URL. This is transparent to the user.
>   * If a matching _ExternalURL_ setting isn&#8217;t found, CAS-01 will look for an Exchange 2007 Client Access server that has the **ExternalURL** property configured, regardless of matching. If one is found, CAS-01 will redirect to this external URL. This will result in the user being prompted for authentication.
>   * If no matching _ExternalURL_ setting is found, CAS-01 will look for an Exchange 2007 Client Access server with an **InternalURL** property that has an _InternalAuthenticationMethods_ setting identical to the InternalAuthenticationMethods setting on the Exchange 2010 Client Access server. If one is found, CAS-01 will redirect to this InternalURL. If forms-based authentication is enabled, this will result in a single sign-on redirection.
>   * If no matching InternalURL is found, CAS-01 will look for an Exchange 2007 Client Access server with an InternalURL configured, regardless of matching. If one is found, CAS-01 will redirect to this InternalURL. This will result in the user being prompted for authentication.

This is all pretty clear right? Wrong, this the above statements only take into account the internal OWA experience. If you are publishing external access via TMG you cannot use forms based authentication, it simply does not work, you have to use basic authentication (or windows integrated but that is another story) and let TMG do the work of providing SSO and handling the user experience.  So if you read carefully, what we really want from an external access perspective is for either the first or the third action to occur externally (if the first does occur, TMG does the FBA work so that is NOT enabled on the virtual directory). And from an internal perspective we want the first action to occur right away.

So in order to get a seamless 2010/2007 coexistence with the pretty forms based authentication end user experience you have to do a few extra steps. Here is a generic diagram of what the end-goal infrastructure looks like.

<div id="attachment_573" style="width: 310px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/07/Exchange2010and2007-coexistence.jpg"><img class="size-medium wp-image-573" title="Exchange2010and2007-coexistence" src="/wp-content/uploads/2012/07/Exchange2010and2007-coexistence.jpg?resize=300%2C138" alt="" width="300" height="138" srcset="/wp-content/uploads/2012/07/Exchange2010and2007-coexistence.jpg?resize=300%2C138 300w, /wp-content/uploads/2012/07/Exchange2010and2007-coexistence.jpg?w=1003 1003w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Exchange2010and2007-coexistence
  </p>
</div>

As you cannot have forms based authentication (hereafter referred to as FBA) on your TMG externally published owa virtual directory, we need to create another virtual directory on each cas server for internal access only. Otherwise internal end users get an unsightly basic authentication pop-up. To do this you will need to assign another IP to each hub/cas server. Note that the IP address can either be assigned on the same nic or on its own dedicated nic. I prefer both IPs to be on the same nic to eliminate any ambiguity which the [strong host model][2] introduces to the environment. With the IPs is on the same nic you will need to disable dns registration on the nic, delete any dns records already registered, and manually create the A record for the Exchange 2010 CAS servers according to your environment .

Since I’m a huge fan of workbooks as a method of documenting an environment here is a workbook I typically use for a cas array scenario (with some fictional data):

[<img class="alignnone size-medium wp-image-574" title="CAS-Array-Workbook" src="/wp-content/uploads/2012/07/CAS-Array-Workbook.jpg?resize=300%2C231" alt="" width="300" height="231" srcset="/wp-content/uploads/2012/07/CAS-Array-Workbook.jpg?resize=300%2C231 300w, /wp-content/uploads/2012/07/CAS-Array-Workbook.jpg?w=749 749w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]

So we will create another website just for internal use called “Exchange-Internal” and leave the default web site to be the external access site. Oh and do yourself a favor and do not change the default web site name in IIS. To do this, run the following on each server. Substitute the IP address in the third command for the local server internal IP.

<pre># Create the new internal site and virtual directories</pre>

<pre>Import-Module WebAdministration</pre>

<pre>mkdir c:\inetpub\exchange-internal</pre>

<pre>New-Website -Name "Exchange-Internal" -IPAddress "192.168.0.10<strong>X</strong>" -PhysicalPath "C:\inetpub\exchange-internal\" -Port 443 -Ssl</pre>

<pre>New-ActiveSyncVirtualDirectory -WebSiteName "Exchange-Internal" –InternalURL https://owa.contoso.com/Microsoft-Server-ActiveSync</pre>

<pre>New-WebServicesVirtualDirectory -WebSiteName "Exchange-Internal" –InternalURL https://owa.contoso.com/ews/exchange.asmx -Force</pre>

<pre>New-AutodiscoverVirtualDirectory -WebSiteName "Exchange-Internal" –InternalURL https://autodiscover.contoso.com/autodiscover</pre>

<pre>New-OWAVirtualDirectory -WebSiteName "Exchange-Internal" –InternalURL https://owa.contoso.com/owa</pre>

<pre>New-OABVirtualDirectory -WebSiteName "Exchange-Internal" -InternalURL https://owa.contoso.com/OAB</pre>

<pre>New-ECPVirtualDirectory -WebSiteName "Exchange-Internal" -InternalURL https://owa.contoso.com/ECP</pre>

<pre></pre>

<pre># Make ssl a requirement on the root directory</pre>

<pre>Set-WebConfigurationProperty -Filter //security/access -name sslflags -Value "Ssl" -PSPath IIS:\ -Location "Exchange-Internal/"</pre>

<pre>Set-WebConfigurationProperty -Filter //security/access -name sslflags -Value "Ssl" -PSPath IIS:\ -Location "Default Web Site/"</pre>

<pre></pre>

<pre>#Setup http redirection</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name enabled -Value "true" -PSPath IIS:\ -Location "Exchange-Internal/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name destination -Value "https://owa.contoso.com/owa" -PSPath IIS:\ -Location "Exchange-Internal/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name ChildOnly -Value "true" -PSPath IIS:\ -Location "Exchange-Internal/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name httpResponseStatus -Value "Found" -PSPath IIS:\ -Location "Exchange-Internal/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name enabled -Value "true" -PSPath IIS:\ -Location "Default Web Site/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name destination -Value "https://owa.contoso.com/owa" -PSPath IIS:\ -Location "Default Web Site/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name ChildOnly -Value "true" -PSPath IIS:\ -Location "Default Web Site/"</pre>

<pre>Set-WebConfigurationProperty -Filter //httpRedirect -Name httpResponseStatus -Value "Found" -PSPath IIS:\ -Location "Default Web Site/"</pre>

Run these from any of the exchange 2010 servers

<pre># Set your external virtual directories to be basic only</pre>

<pre>Set-OwaVirtualDirectory "hubcas1\owa (default web site)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic" -BasicAuthentication $true -WindowsAuthentication $false
Set-ECPVirtualDirectory "hubcas1\ecp (default web site)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic" -BasicAuthentication $true -WindowsAuthentication $false
Set-OwaVirtualDirectory "hubcas2\owa (default web site)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic" -BasicAuthentication $true -WindowsAuthentication $false
Set-ECPVirtualDirectory "hubcas2\ecp (default web site)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic" -BasicAuthentication $true -WindowsAuthentication $false</pre>

&nbsp;

<pre># Set your internal virtual directories to be FBA</pre>

<pre>Set-OwaVirtualDirectory "hubcas1\owa (Exchange-Internal)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic","Fba" -FormsAuthentication $true -WindowsAuthentication $false
Set-ECPVirtualDirectory "hubcas1\ecp (Exchange-Internal)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic","Fba" -FormsAuthentication $true -WindowsAuthentication $false
Set-OwaVirtualDirectory "hubcas2\owa (Exchange-Internal)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic","Fba" -FormsAuthentication $true -WindowsAuthentication $false
Set-ECPVirtualDirectory "hubcas2\ecp (Exchange-Internal)" -ExternalUrl https://owa.contoso.com/owa -ExternalAuthenticationMethods "Basic","FBA" -FormsAuthentication $true -WindowsAuthentication $false</pre>

Once this has been done, then go into IIS on each server and you will see that the Exchange-Internal site is stopped. This is because it automatically adds in 127.0.0.1 to be listening on ports 80 and 443, which is already setup on your default web site. Select the Exchange-Internal site, then select “bindings..” on the right and delete both references to 127.0.0.1 and modify the remaining https entry to use either an internal cert explicitly created for this purpose or your public cert. Then restart IIS on both 2010 servers. For whatever reason, 127.0.0.1 will periodically get added back in to the exchange-internal site you created. Be cognizant of this when updating/rebooting your servers. It is not consistent and I’ve yet to find out what causes this behavior.

If you are trying to coexist with an exchange 2007 environment which was directly published to the internet instead of through ISA/TMG then you may have to perform the same virtual directory creation on the 2007 side of things as well, otherwise internal redirection will not occur seamlessly.

Now on TMG all you need to add is an additional firewall rule for Exchange 2007 OWA using the same listener as your Exchange 2010 rules but pointing to your Exchange 2007 external CAS site. Exchange 2010 will proxy all other requests (activesync, ews, oa, & autodiscover). To reduce IP confusion and make sure that TMG is hitting just the external sites on both 2010 and 2007 I tend to publish rules to server farm objects which point directly to IP addresses. This is because DNS for the Exchange environment will be pointing to the internal forms based authenticated owa virtual directories. This has the additional benefit of allowing you to test your rules and better monitor your published services. Although you could just use a TCP to port 443 as your connectivity verifier, I like to use more realistic test of services that actually hit the application pool. So I’ll copy iisstart.htm from C:\inetpub\wwwroot to %ExchangeInstallPath%ClientAccess\OWA and then change the verification to be https://*/owa/iisstart.htm

On the Exchange 2007 servers you can set the externalurl for owa to be <https://legacy.contoso.com/owa> (even before the migration of internal/external DNS entries for owa). All other externalurl settings in Exchange 2007 can be set to $null to force proxying to them.

# Tip #3: TMG may not observe the local hosts file

This is more of a side note than a tip. If you are doing testing with TMG and thinking that you can use your local hosts file as a way to trump DNS for lookups you may just be spinning your wheels. Firstly, TMG keeps its own cache for dns so a simple ipconfig /flushdns will not clear it out. That record will stay cached until the TTL for that DNS record will time out (default of 20 minutes if using a Windows based DNS server which, if you are reading this article, you know you are…).

To manipulate and clear the DNS cache for TMG you need a special tool from the [TMG tools and development kit which can be downloaded here][4]. To futz with the TMG DNS cache download and extract DNSToolsPack to your TMG install directory. Then run dnstools.exe /c from this directory to clear out the cache.

# Tip #4: Be patient when adding mailbox databases

Part of the mailbox database creation wizard includes an option to mount the database. You may find yourself getting errors if you select this option. This is especially true of larger environments with many DCs and sites. Don’t freak out, this is common. Either force a replication (include all partitions so: repadmin /syncall /Aped) or just wait a bit then go and manually mount the database.

# Tip #5: If AD is not working well then neither will Exchange 2010

This seems like a no-brainer but you would be surprised at how many companies ignore their AD infrastructure, do not keep sites and serviced updated, or leave artifacts from long dead DCs in their environment. On my first Exchange 2010 migration I ran into issues wherein two exchange servers in the same forest but separate domains could not interoperate. An Exchange 2003 server for a specific subdomain kept running into authentication issues when trying to send mail to the new Exchange 2010 servers. The Exchange 2003 server was on the opposite end of the globe in a subdomain which I was not granted access. I was assured up and down that the adprep I instructed the admin to run was completed successfully. At the time I was baffled so I just manually dropped the permissions on the Exchange 2010 listener to allow true anonymous connections from the 2003 server.  I kept on running into other issues with the Exchange 2010 upgrade and was eventually granted access to the other subdomains in the forest. What I found was that, even though all the exchange servers showed up in the legacy interop group in the domain I was upgrading, that they did not show up on some of the remote DCs. The subdomain I was working in showed no replication issues either. But that did not matter as the AD replication topology for the forest converged in such a way that an upstream link issue was preventing replication to just a few subdomains. Once this was resolved everything started working beautifully.

Another AD issue I frequently come across is AD sites and services being completely ignored. Common, AD sites and services needs some love too admins! You can run the following script to get a list of IP addresses which are attempting to logon and not finding an assigned site ([credit to this script’s author][5])

<pre>$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()</pre>

<pre><strong>Write-Host</strong> '..current domain is' $dom</pre>

<pre></pre>

<pre><strong>Write-Host</strong> '..getting all domain controllers in domain'</pre>

<pre>$dcs = $dom | <strong>%</strong> { $_.DomainControllers } | <strong>Select</strong> Name</pre>

<pre>$at = ($dcs | <strong>Measure-Object</strong>).count</pre>

<pre></pre>

<pre>foreach ($dc in $dcs)</pre>

<pre>    {</pre>

<pre>        $path = '\\' + $dc.name + '\admin$\debug\netlogon.log'</pre>

<pre>        if ((<strong>test-path</strong> $path) -eq $true)</pre>

<pre>            {</pre>

<pre>                <strong>Write-Host</strong> "..collecting logfile from ($at)" $path</pre>

<pre>                [array]$colLogs += <strong>gc</strong> $path</pre>

<pre>            }</pre>

<pre>            $at --</pre>

<pre>    }</pre>

<pre></pre>

<pre><strong>Write-Host</strong> '..combining logs'</pre>

<pre>$outFile = '.\expFile.txt'</pre>

<pre>$colLogs | <strong>Out-File</strong> $outFile</pre>

<pre></pre>

<pre><strong>Write-Host</strong> '..importing combined log as csv'</pre>

<pre>$importString = <strong>Import-Csv</strong> $outFile <em>-Delimiter</em> ' ' <em>-Header</em> Date,Time,Domain,Error,Name,IPAddress</pre>

<pre></pre>

<pre><strong>Write-Host</strong> '..exporting results'</pre>

<pre>$importString | <strong>select</strong> Date, Name, IPAddress | <strong>sort</strong> IPAddress <em>-Unique</em> | <strong>Export-Csv</strong> .\Missing-AD-Sites.csv</pre>

Be forewarned that in a larger environment this script can consume a large amount of memory. In those cases just get a copy of all the files it gathers and manually massage the data to get your missing sites.

# Tip #6: Outlook Anywhere affects all mailboxes

If you are not currently using outlook anywhere and enable it in your new Exchange 2010 servers then that affects how autodiscover populates in outlook (see Tip #7 below). If you are not careful and enable OA on the 2010 side before, say, upgrading the san cert on the 2007 servers you could run into a situation where end users start getting pop-ups. So take caution before just flipping things over.

# Tip #7: The outlook provider CertPrincipalName is tricky

Without going into a huge essay on how the outlook provider information is utilized let me discuss the layman’s explanation of what the EXPR CertPrincipalName does. It is utilized as part of the autodiscover information for an outlook profile and fills out the following blanked out value in the proxy settings:

<div id="attachment_575" style="width: 310px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/07/Outlook-Proxy-Value.jpg"><img class="size-medium wp-image-575" title="Outlook-Proxy-Value" src="/wp-content/uploads/2012/07/Outlook-Proxy-Value.jpg?resize=300%2C265" alt="Outlook-Proxy-Value" width="300" height="265" srcset="/wp-content/uploads/2012/07/Outlook-Proxy-Value.jpg?resize=300%2C265 300w, wp-content/uploads/2012/07/Outlook-Proxy-Value.jpg?w=462 462w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Outlook-Proxy-Value
  </p>
</div>

Note the wording in the screenshot, “principal name” says it all. It is not saying “subject alternative name” so this value must be the primary cert name on whichever certificate you are using for your deployment if you are going to set it.

> Update 1: An astute coworker of mine noted that newer versions of Outlook may not require the principal name and may be able to process SAN certificate values without issue.
> 
> Update 2: That same astute coworker followed through with Microsoft and discovered that Outlook version has nothing to do with the ability to recognize SAN cert names when using OA. Apparently it is OS related and anything after Vista SP1 will not experience the pop-up issue if the OA server name fails to coincide with the principal name of the cert. Any OS after Vista SP1 will recognize the SAN name and be happy. Props to [@petersassoc][6]

For the most part this invisible global value should not be changed. By default the CertPrincipalName value is $null and this is a good thing. That keeps your autodiscover information from being tied down to a single url for outlook anywhere access. If you are using a wildcard certificate though then you must change this value.

Here is how you can set it:

<pre>Set-OutlookProvider -Identity EXPR -CertPrincipalName msstd:*.contoso.com</pre>

What are other scenarios which require you to update the certprincipalname? Well if you have a different subject name on your ssl san certificate than the externalhostname configured for outlook anywhere on your cas server you might also experience annoying pop-ups in outlook (I think this may be resolved in newer versions of Outlook). So if your certificate certificate principal name is autodiscover.contoso.com and you setup outlook anywhere to connect to owa.contoso.com then you may need to set this value like so:

<pre>Set-OutlookProvider -Identity EXPR -CertPrincipalName msstd:autodiscover.contoso.com</pre>

Another instance where you want to set this value is if you are following [the MS best practice for multiple datacenter failover DR scenarios][7].

> _For Outlook Anywhere clients, we recommend that you use a single Subject Alternative Name (SAN) certificate for each datacenter, and include multiple host names in the certificate. To ensure Outlook Anywhere connectivity after a database, server or datacenter switchover, you must use the same Certificate Principal Name on each certificate, and configure the Outlook Provider Configuration object Active Directory with the same Principal Name in Microsoft-Standard Form (msstd). For example, if you use a Certificate Principal Name of mail.contoso.com, you would configure the attribute as follows:_
> 
> _Set-OutlookProvider EXPR -CertPrincipalName &#8220;msstd:mail.contoso.com&#8221;_

&nbsp;

# Tip #8: OA vs MAPI

If you have gotten this far into my post then I may as well add that if you find yourself changing the outlook provider because of authentication pop-ups in outlook for users who are on the **internal** network then you maybe need to take a step back and ask yourself just why outlook is connecting via OA internally. You see, internally clients should connect via MAPI first then, if they cannot connect directly or if slow network connection is found (slower than 128Kb), Outlook will connect via OA (unless explicitly configured otherwise).  I’ve seen some people never setup MAPI on their load balancers (just didn’t think to do so). Other times if AD sites and services is not up to date the Outlook client may be getting served up the incorrect connection info. Here is how this information populates from autodiscover to Outlook:

1. If the request is made via a direct connection (internal) the EXCH provider name returned by autodiscover is the _InternalURL_ configured on the best CAS server based on AD site for EWS, ActiveSync, ECP, OAB, and UM virtual directories. This is of course only going to occur with non-domain devices. Domain joined devices would query AD for an SCP instead (which can be changed with set-clientaccessserver -autodiscoverserviceinternaluri <newscp>)

2. If the autodiscover request is made by an OA HTTP connection (external), the EXPR provider name returned is the _ExternalURL_ configured on the best CAS server for the same services. If the externalurl is not set it will failover to the InternalURL

# Tip #9: Add Exchange Trusted Subsystem group to your Exchange 2007 server’s local admin group

Not sure why, but Exchange trusted subsystem is never added to the Exchange 2007 servers in an environment.  I typically run /preparead as that should encompass all of the AD preparation [steps as described in this technet article][8]. Even if it succeeds I still do not end up with the Exchange Trusted Subsystem group being added to the 2007 server’s local admin group though. And that is fine, but then I cannot get all the Exchange 2010 and 2007 info from the Exchange 2010 console. Instead I get pesky warnings about permissions on the 2007 servers. When troubleshooting coexistence it is really nice to be able to get all of your information from one console rather than having to bounce back and forth. So I tend to add the exchange trusted subsystem group to the local admin group of the 2007 servers manually. Right or wrong, I just find it to be convenient.

# Conclusion

There are many moving parts when it comes to operating and upgrading Exchange 2010, this was just a small subset of them. Hopefully they help you out in some way. If I’m blatantly wrong on some of my assertions or statements please let me know. I&#8217;d rather be proven wrong than be deluded into believing that I am right 😉

 [1]: http://technet.microsoft.com/en-us/library/bb310763.aspx
 [2]: http://technet.microsoft.com/en-us/magazine/2007.09.cableguy.aspx
 [3]: /wp-content/uploads/2012/07/CAS-Array-Workbook.jpg
 [4]: http://www.microsoft.com/download/en/details.aspx?id=11183
 [5]: http://www.powershellneedfulthings.com/?p=396
 [6]: https://twitter.com/petersassoc "Peters & Associates"
 [7]: http://technet.microsoft.com/en-us/library/dd638104.aspx#WSR
 [8]: http://technet.microsoft.com/en-us/library/bb125224.aspx