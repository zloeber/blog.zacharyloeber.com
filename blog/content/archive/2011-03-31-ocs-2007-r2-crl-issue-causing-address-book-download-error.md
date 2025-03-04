---
title: 'OCS 2007 R2: CRL Issue Causing Address Book Download Error'
author: Zachary Loeber
type: post
date: 2011-03-31T15:21:09+00:00
excerpt: MS CRL Published location w/ IIS7.5 Causes Office Communicator address book download issues.
url: /blog/2011/03/31/ocs-2007-r2-crl-issue-causing-address-book-download-error/
categories:
  - Microsoft
  - Office Communicator Server
  - Security
  - System Administration
tags:
  - OCS 2007 R2
  - Security
  - System Administration
  - Windows

---
I ran into this issue recently. End users experienced a red splat in communicator exhibiting that there was an issue syncing the corporate address book. I found <a title="OCS 2007 R2 CRL Issue" href="http://blog.danovich.com.au/2009/11/04/office-communicator-error-cannot-synchronize-address-book/" target="_blank">this excellent article</a> explaining how an invalid Certificate Revocation List error may be causing this issue. My issue was slightly similar in nature but with some caveats.

<!--more-->

Firstly I had no issues getting to the CRL that was published. You can get the published CRL distribution points for the OCS pool by going to https://yourpool.contoso.internal/Abs/Ext/Files/Invalid\_AD\_Phone_Numbers.txt in IE, clicking on the security lock next to the url in the browser, and selecting &#8220;view certificate&#8221;. From here in the details tab select &#8220;CRL Distribution Points&#8221; and copy the data into notepad for future use.

In my case I had two URLs:

<pre>URL=ldap:///CN=Contoso%20US%20Issuing%20CA%201,CN=CONTOSOCA1,CN=CDP,CN=Public%20Key%20Services,CN=Services,CN=Configuration,DC=contoso,DC=internal?certificateRevocationList?base?objectClass=cRLDistributionPoint
URL=http://internal.contoso.com/pki/Contoso%20US%20Issuing%20CA%201+.crl</pre>

If I went directly to the http URL I was able to download the crl without issues. I was not certain how to test the ldap URL but a quick search gave me what I needed to do so:

<pre>certutil -URL ldap:///CN=Contoso%20US%20IssuingCA%201,CN=CONTOSOCA1,CN=CDP,CN=Public%20Key%20Services,CN=Services,CN=Configuration,DC=contoso,DC=internal?certificateRevocationList?base?objectClass=cRLDistributionPoint</pre>

When the interface comes up select the Retrieve button to grab the CRLs (from CDP). You should get a list that comes up of the Base CRL and some deltas. In my case though the HTTP Url showed as &#8220;Failed&#8221;. As I knew that the URL did work properly from a manual check I was a bit perplexed as to why this was showing as failed.

Well what it ended up being was that the original site for which the CRL HTTP URL was published was migrated from an older IIS5 server to IIS7.5 and <a title="IIS7 and the plus sign" href="http://www.ifinity.com.au/Blog/EntryId/60/404-Error-in-IIS-7-when-using-a-Url-with-a-plus-sign-in-the-path" target="_blank">IIS 7.5 doesn&#8217;t respond well to the &#8220;+&#8221; character in URLs apparently</a>. The resolution was to <a title="Convince IIS7.5 that plusses are spaces" href="http://n8v.enteuxis.org/2010/07/convincing-iis7-to-accept-urls-containing-plusses/" target="_blank">convince IIS7.5 that pluses are spaces</a> (alternatively don&#8217;t use the + character in your published CRL URL or filenames).

After this was resolved I tested communicator after setting the GAL download initial delay to zero with a registry hack.

For 32 bit OSes:

<pre>Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Communicator]
“GalDownloadInitialDelay”=dword:00000000</pre>

For 64 bit OSes:

<pre>Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Wow6432Node\Policies\Microsoft\Communicator]
“GalDownloadInitialDelay”=dword:00000000</pre>

When I restarted Communicator the red splat went away for a few hours but eventually came back. After resetting the front end OCS servers it went away permanently.

&nbsp;

&nbsp;

&nbsp;