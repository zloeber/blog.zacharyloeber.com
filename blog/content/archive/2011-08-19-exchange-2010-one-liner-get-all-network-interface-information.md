---
title: 'Exchange 2010 One-liner: Get All Network Interface Information'
author: Zachary Loeber
type: post
date: 2011-08-19T16:57:15+00:00
excerpt: 'Here are a few quick powershell one-liners to get all the network interface information in your exchange environment:'
url: /blog/2011/08/19/exchange-2010-one-liner-get-all-network-interface-information/
wordbooker_options:
  - 'a:9:{s:18:"wordbook_noncename";s:10:"8c6843c884";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";}'
wordbooker_extract:
  - |
    Here are a few quick powershell one-liners to get all the network interface information in your exchange environment:
    $ExchServers=(Get-ExchangeServer); @(foreach ($Srv in $ExchServers) {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter I ...
categories:
  - Exchange
  - Exchange 2010
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Networking
  - Powershell
  - System Administration
  - Windows

---
Here are a few quick powershell one-liners to get all the network interface information in your exchange environment:

<pre>$ExchServers=(Get-ExchangeServer); @(foreach ($Srv in $ExchServers) {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Srv.Name | select @{Name="Server";Expression={$Srv.Name}},@{Name="DNS Host Name";Expression={$_.DNSHostName}},@{Name="Server Role";Expression={$Srv.ServerRole}},Description,@{Name="IP Address";Expression={$_.IPAddress}},@{Name="IP Subnet";Expression={$_.IPSubnet}},@{Name="Default Gateway";Expression={$_.DefaultIPGateway}},@{Name="Mac Address";Expression={$_.MacAddress}},@{Name="DNS Suffix Search Order";Expression={$_.DNSDomainSuffixSearchOrder}},@{Name="DNS Server Search Order";Expression={$_.DNSServerSearchOrder}},FullDNSRegistrationEnabled}) |Export-Csv -NoTypeInformation "C:\Temp\Exchange-network.csv"</pre>

If you just want interface information for Exchange 2010 servers:

<pre>$ExchServers=(Get-ExchangeServer | where {$_.ServerRole -ne "None"}); @(foreach ($Srv in $ExchServers) {Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Srv.Name | select @{Name="Server";Expression={$Srv.Name}},@{Name="DNS Host Name";Expression={$_.DNSHostName}},@{Name="Server Role";Expression={$Srv.ServerRole}},Description,@{Name="IP Address";Expression={$_.IPAddress}},@{Name="IP Subnet";Expression={$_.IPSubnet}},@{Name="Default Gateway";Expression={$_.DefaultIPGateway}},@{Name="Mac Address";Expression={$_.MacAddress}},@{Name="DNS Suffix Search Order";Expression={$_.DNSDomainSuffixSearchOrder}},@{Name="DNS Server Search Order";Expression={$_.DNSServerSearchOrder}},FullDNSRegistrationEnabled}) |Export-Csv -NoTypeInformation "C:\Temp\Exchange2010-network.csv"</pre>

&nbsp;