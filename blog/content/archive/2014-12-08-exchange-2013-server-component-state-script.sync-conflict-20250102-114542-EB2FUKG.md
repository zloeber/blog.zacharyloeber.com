---
title: 'Exchange 2013: Server Component State Script'
author: Zachary Loeber
type: post
date: 2014-12-09T01:28:23+00:00
excerpt: Use PowerShell to return Exchange 2013 component states, their most recent requester, and other relevant information.
url: /blog/2014/12/08/exchange-2013-server-component-state-script/
categories:
  - Active Directory
  - Exchange 2013
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2013
  - Microsoft
  - Powershell
  - PSC
  - Scripting
  - Sysadmin
  - System Administration

---
Exchange 2013 includes some powershell commands which allow you to set and view several components in the messaging infrastructure. This is important to be aware of as it means all Exchange related services can be running when looking at them in service manager (services.msc) but not actually doing anything. I went ahead put together a script to better gather this information for administrators.

<!--more-->

The script itself isn’t all that fancy but it provides a bit more information in a single set of results that the standard cmdlets do. For starters it includes the most recent timestamp and requester information. This is needed as a component can be put into different states by different requesters and there are two sources for this requester information, the registry and AD. If there is a divergence between these sources the most recent timestamp should be considered accurate. Oh, it is also possible for a component state to be set by multiple requesters as well. The default cmdlet returns both of these sources and all requesters but leaves it up to you to sort out the details.

All this script does is collate both sources, sorts them in descending order, and picks the first one in the list. I guess be warned that if there are multiple timestamps that are the same no preference is given one way or another. I do include in the results if there are multiple requesters though. This is handy in case you find yourself attempting to set the component status and find that they are not coming online (you need to set the state from all the requesters).

Here are some exchange component state cliff notes I’ve included in the script comments for your convenience:

<pre class="lang:powershell decode:true ">&lt;#
.SYNOPSIS
Return Exchange 2013 component states, their most recent requester, and other relevant information.
.DESCRIPTION
Return Exchange 2013 component states, their most recent requester, and other relevant information.
.PARAMETER NonActiveOnly
Only return results for components not in an active state.
.PARAMETER ServerFilter
Limit results to specific servers.

.EXAMPLE
PS &gt; Get-Exchange2013ComponentStateHistory | ft -AutoSize

Description
-----------
Show all component states for all servers along with their most recent requester.

.EXAMPLE
PS &gt; Get-Exchange2013ComponentStateHistory | Where {($_.Requesters).Count -gt 1 } | ft -AutoSize

Description
-----------
List all components with more than 1 historical requester

.NOTES
Author: Zachary Loeber
Requires: Powershell 3.0, Exchange 2013
Version History
1.0.0 - 12/07/2014
- Initial release

The component state cliff notes:
    Component State Requesters
    * HealthAPI - Reserved by managed availability (probably shouldn't ever use this if setting component states)
    * Maintenance
    * Sidelined
    * Functional
    * Deployment

    Multiple requesters can set a component state. 
    Note: When there are multiple requesters 'Inactive' is prioritized over 'Active'

    Global Components
    * ServerwideOffline - Overrules the states of all other components except for Monitoring and RecoveryActionsEnabled

    Managed Availability Components (I think)
    * Monitoring
    * RecoveryActionsEnabled

    Transport Components (Only components which can be in 'draining' state)
    * FrontendTransport
    * HubTransport

    All other components
    * AutoDiscoverProxy
    * ActiveSyncProxy
    * EcpProxy
    * EwsProxy
    * ImapProxy
    * OabProxy
    * OwaProxy
    * PopProxy
    * PushNotificationsProxy
    * RpsProxy
    * RwsProxy
    * RpcProxy
    * UMCallRouter
    * XropProxy
    * HttpProxyAvailabilityGroup
    * ForwardSyncDaemon
    * ProvisioningRps
    * MapiProxy
    * EdgeTransport
    * HighAvailability
    * SharedCache

.LINK
https://github.com/zloeber/Powershell
.LINK
http://zacharyloeber.com
#&gt;</pre>

You can download the script at the [Microsoft Technet Gallery][1] or from my [github repo][2].

 [1]: https://gallery.technet.microsoft.com/Exchange-2013-Server-97de9a3c
 [2]: https://github.com/zloeber/Powershell/blob/master/Exchange/Get-Exchange2013ComponentStateHistory.ps1