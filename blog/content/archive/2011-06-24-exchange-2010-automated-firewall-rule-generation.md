---
title: 'Exchange 2010: Automated Firewall Rule Generation'
author: Zachary Loeber
type: post
date: 2011-06-24T16:40:50+00:00
excerpt: "A single, or even a dual site Exchange 2010 deployment does not usually require too much internal firewall manipulation. But if you have to setup a Exchange 2010 environment where there are many global sites or a heavily segmented network, the number of firewall requests required to get a fully functioning configuration working can be daunting. Wouldn't it be nice to have some of those firewall rules automatically generated for you?"
url: /blog/2011/06/24/exchange-2010-automated-firewall-rule-generation/
categories:
  - Exchange
  - Microsoft
  - Networking
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Powershell
  - Security
  - System Administration

---
A single, or even a dual site Exchange 2010 deployment does not usually require too much internal firewall manipulation. But if you have to setup a Exchange 2010 environment where there are many global sites or a heavily segmented network, the number of firewall requests required to get a fully functioning configuration working can be daunting. Wouldn&#8217;t it be nice to have some of those firewall rules automatically generated for you?

<!--more-->

[Here is a quick powershell script I put together while on vacation to accomplish such a task.][1]

ExchangeEnvironment.csv is a fictitious 2010 environment with three sites, one which has edge servers, the other two go through a third-party antispam vendor (used messagelabs as an example).

FirewallRules.csv is self-explanatory, it contains a tabular list of all the firewall requirements for all roles in an exchange environment. I&#8217;ve connected with Michel de Rooij over at [Eightwone][2] to go over this for accuracy so this may be updated very soon.

Firewall-request.csv is the example output when the script is run as is.

GenerateFirewallRules.ps1 is the hacked together script that takes the two input files and spits out our firewall-request.csv file.

The areas which I&#8217;ve probably not fleshed out so much are where there are exceptions. I tried to think of as many as possible though. Let me know what you think.

 [1]: /wp-content/uploads/2011/06/ExchangeFirewallRequestGenerator.zip "Exchange 2010 Firewall Request Generator"
 [2]: http://eightwone.com/ "Eightwone Blog"