---
title: 'Exchange 2010: Automated Firewall Rule Generation 1.4'
author: Zachary Loeber
type: post
date: 2011-07-29T15:28:07+00:00
excerpt: I made some updates to the automated firewall rule generation script. This includes some updates to the firewall rule spreadsheet to give information on setting setic ports and port ranges for RPC based services. This csv file may be a good general reference even without the script.
url: /blog/2011/07/29/exchange-2010-automated-firewall-rule-generation-1-4/
wordbooker_options:
  - 'a:9:{s:18:"wordbook_noncename";s:10:"6699b921c5";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";}'
wordbooker_extract:
  - I made some updates to the automated firewall rule generation script. This includes some updates to the firewall rule spreadsheet to give information on setting setic ports and port ranges for RPC based services. This csv file may be a good general ref ...
categories:
  - Exchange 2010
  - Networking
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Networking
  - Powershell
  - System Administration

---
I made some updates to the automated firewall rule generation script. This includes some updates to the firewall rule spreadsheet to give information on setting setic ports and port ranges for RPC based services. This csv file may be a good general reference even without the script.

<!--more-->Change Log

1.4 &#8211; Fixed some logic around Client-Network processing to generate just rules to the same site for hub-transport/
  
Client-Access roles and to bypass $SkipSameSite settings.
  
&#8211; Updated the FirewallRules.csv to be more detailed for setting static ports for cross-site dags
  
(This is actually a really convenient reference in its own right)
  
&#8211; Added a region column to the exchange environment csv file for processing
  
1.3 &#8211; Added logic for client-network rules to only process them if they are in the same site as the Role
  
In our input exchange environment csv file if you want 2 sites to generate rules that allow them
  
to reach two other sites instead of just their own you will need to put the network in twice, once
  
for each site like so:
  
Client-Network,10.203.2.0/24,End User Network &#8211; Site1,Site1
  
Client-Network,10.203.2.0/24,End User Network &#8211; Site1,Site2

Download:

[Automated Firewall Rule Generation 1.4][1]

 [1]: /wp-content/uploads/2011/07/GenerateExchangeFirewalls_1-4.zip "Automated Firewall Rule Generation 1.4"