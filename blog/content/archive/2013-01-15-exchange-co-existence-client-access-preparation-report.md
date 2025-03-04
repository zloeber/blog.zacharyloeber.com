---
title: 'Exchange: Co-existence Client Access Preparation Report'
author: Zachary Loeber
type: post
date: 2013-01-16T03:36:50+00:00
url: /blog/2013/01/15/exchange-co-existence-client-access-preparation-report/
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Networking
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - network administration
  - Networking
  - Sysadmin
  - System Administration

---
If you upgrade Exchange in a co-existence scenario (you want to keep the same client access namespace) there is one crucial moment of truth which must be overcome. This is the phase of the migration I&#8217;ve come to call the &#8220;dns flip-over&#8221; or the &#8220;client access part&#8221;. Without preparation this part of the migration can be a real headache as issues are directly experienced by your end users.  This is a simple report card you can use to prepare you for this moment.

<!--more-->

Lets not go into the entire process of an Exchange migration. Instead let us assume your new Exchange environment is in place, your mail is flowing back and forth, and you are ready to &#8220;flip&#8221; over so that client access is going through your new servers. You have many factors to consider;

  * Is the client accessing Exchange from inside or outside the network?
  * What client software is being used?
  * What other services are accessing the old Exchange server?

Here is a quick report card for testing client access as thoroughly as possible prior to changing your internal/external DNS or doing any kind of flip-over. The different tools you can use for doing your tests are varied, for now I&#8217;ll let you decide what to use. Later I may do a quick write up of some I&#8217;m rather fond of using. Anyway, here is the report card you can use to track your testing.

<p style="text-align: center;">
  Exchange Co-Existence Testing Report (<a title="Exchange Co-Existence Testing Report" href="/wp-content/uploads/2013/01/Exchange-Co-Existence-Testing-Report.htm">HTML</a>/<a href="/wp-content/uploads/2013/01/Exchange-Co-Existence-Testing-Report.xlsx">Excel</a>)
</p>