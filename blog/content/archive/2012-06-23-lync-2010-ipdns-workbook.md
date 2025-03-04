---
title: 'Lync 2010: IP/DNS Workbook'
author: Zachary Loeber
type: post
date: 2012-06-23T20:24:40+00:00
url: /blog/2012/06/23/lync-2010-ipdns-workbook/
categories:
  - Lync
  - Microsoft
  - Networking
  - System Administration
tags:
  - Lync
  - Lync 2010
  - Microsoft
  - Networking
  - Sysadmin
  - System Administration

---
I just ran across [a Lync article][1] with all kinds of nice tables which distilled the myriad of DNS/IP addresses in a Lync deployment down to an easy to read format. I happen to have created one of these tables myself for a Lync deployment which included a standard Lync pool, XMPP gateway, Lync Mobility, and a single edge server. I figured others may find some use from it as it auto-populates the dns entries and what they are supposed to point to based on what you fill out for the highlighted cells. Sure you get some of this in the Lync Server 2010 Planning Tool but this offers a slightly different view of the environment as well as a nice one page overview.<!--more-->

All that needs to be filled out are the yellow cells. Everything else auto-populates. The example data is for an environment where the edge internal lies directly on the internal network. Here is a quick screenshot of the workbook:

<div id="attachment_559" style="width: 160px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/06/Lync-Workbook.jpg"><img class="size-thumbnail wp-image-559" title="Lync-Workbook" src="/wp-content/uploads/2012/06/Lync-Workbook.jpg?resize=150%2C150" alt="Lync Workbook Example" width="150" height="150" srcset="/wp-content/uploads/2012/06/Lync-Workbook.jpg?resize=150%2C150 150w, wp-content/uploads/2012/06/Lync-Workbook.jpg?zoom=2&resize=150%2C150 300w, wp-content/uploads/2012/06/Lync-Workbook.jpg?zoom=3&resize=150%2C150 450w" sizes="(max-width: 150px) 100vw, 150px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Lync Workbook Example
  </p>
</div>

&nbsp;

[Download Lync IP and DNS Workbook Template][2]

 [1]: http://blogs.technet.com/b/nexthop/archive/2011/12/07/useful-tips-for-testing-your-lync-edge-server.aspx "Useful Tips For Testing Your Lync Edge Server"
 [2]: /wp-content/uploads/2012/06/Lync-IP-and-DNS-Workbook-Template.xlsx