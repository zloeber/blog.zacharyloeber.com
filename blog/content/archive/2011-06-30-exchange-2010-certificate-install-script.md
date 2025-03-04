---
title: 'Exchange 2010: Certificate Install Script'
author: Zachary Loeber
type: post
date: 2011-06-30T15:39:27+00:00
excerpt: Many of the cert providers require that you install both an intermediary and a root trusted cert on the servers which you are configuring your newly requested Unified Communications certificate on. If you are doing an Exchange migration including several ISA/TMG/Exchange (2003 and 2010) servers this can be a tedious process. Here is the quick way to install all three certificates once they are on the server
url: /blog/2011/06/30/exchange-2010-certificate-install-script/
categories:
  - Exchange
  - Microsoft
  - Security
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Security
  - System Administration

---
Many of the cert providers require that you install both an intermediary and a root trusted cert on the servers which you are configuring your newly requested Unified Communications certificate on. If you are doing an Exchange migration including several ISA/TMG/Exchange (2003 and 2010) servers this can be a tedious process. Here is the quick way to install all three certificates once they are on the server

<!--more-->

Assuming you are installing from entrust you can install the intermediary (chain) and root trusted certs with certutil. You can also install your pfx certificate this way. Here is the batch file to do so:

<pre>certutil -addstore CA entrust_chain.cer
certutil -addstore root entrust_root.cer
certutil -p &lt;yourpassword&gt; -importpfx webmail.pfx</pre>

Nothing ground-breaking but it does save a whole lot of clicks for larger environments. 🙂