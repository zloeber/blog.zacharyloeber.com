---
title: Exchange – Notify Forwarded Accounts Script
author: Zachary Loeber
type: post
date: 2011-01-10T20:00:19+00:00
excerpt: In cleaning up a large number of disabled users I wanted a way to notify a large number of users specifically that they were being forwarded e-mail from another account. This was part of an effort to clean up AD a bit before moving everyone over to Exchange 2010 but it can be used independently of any one project as part of a general AD maintenance plan.
url: /blog/2011/01/10/exchange-notify-forwarded-accounts-script/
wordbooker_options:
  - 'a:8:{s:18:"wordbook_noncename";s:10:"4513bd7e93";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";}'
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
  - Uncategorized
tags:
  - Active Directory
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration

---
In cleaning up a large number of disabled user accounts in AD I wanted a way to notify a large number of users specifically that they were being forwarded e-mail from another account. This was part of an effort to clean up AD a bit before moving everyone over to Exchange 2010 but it can be used independently of any one project as part of a general AD maintenance plan.

You can download the script here,  just rename to ps1 and run from a machine with exchange 2010 EMC installed.

[notify-accounts-with-forwarders-generic][1]

 [1]: /wp-content/uploads/2011/01/notify-accounts-with-forwarders-generic.txt