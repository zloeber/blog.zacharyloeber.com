---
title: 'Exchange 2010 SP1: Web Services Fix'
author: Zachary Loeber
type: post
date: 2010-10-12T20:22:25+00:00
excerpt: "I'm utilizing 2 CAS servers behind an F5 load balancer and was finding that a migrated user to my new CAS array would get a red spat in communicator and get authorization prompts for the autodiscover url. I fixed it, finally, just today."
url: /blog/2010/10/12/exchange-2010-sp1-web-services-fix/
categories:
  - Exchange
  - Microsoft
  - Office Communicator Server
  - System Administration

---
I&#8217;m utilizing 2 CAS servers behind an F5 load balancer and was finding that a migrated user to my new CAS array would get a red spat in communicator and get authorization prompts for the autodiscover url. I fixed it, finally, just today.

<!--more-->Some people recommend using setspn to add a service principal name for the cas server to help fix the autodiscover prompting. Do NOT do this in a load balanced situation as you can only have one spn per account in AD. Otherwise duplicates defeat the purpose of having the spn anyways (to uniquely locate a service in AD for kerberos authentication). If you do want kerberos you need to setup a shared service account to use via this complicated 

<a title="procedure" href="http://technet.microsoft.com/en-us/library/ff808312.aspx" target="_blank">procedure</a>.

Also, <a title="this" href="http://blogs.msdn.com/b/scottos/archive/2008/10/16/why-is-communicator-prompting-me-for-credentials.aspx" target="_blank">this</a> procedure may fix the issue for communicator accessing autodiscover over the internet.

To fix this in a cas array where you are not implementing kerberos for autodiscover and web services MAKE SURE TO DELETE ALL HTTP SPNs.

If an HTTP spn is showing when you run setspn -L <cas servername> then just go ahead and remove it, (setspn -D http/autodiscover.contoso.com casservername). Yup remove them all. Then things will start to use NTLM authentication instead of trying Kerberos and giving annoying autodiscover prompts.

Hope this helps someone as I never ran across this in any deployment documentation from either F5 or Microsoft or anyone else.