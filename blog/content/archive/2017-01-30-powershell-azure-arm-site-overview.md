---
title: 'PowerShell: Azure ARM Site Overview'
author: Zachary Loeber
type: post
date: 2017-01-31T03:23:32+00:00
url: /blog/2017/01/30/powershell-azure-arm-site-overview/
categories:
  - Azure
  - Networking
  - Powershell
  - System Administration
tags:
  - Azure
  - Azure ARM
  - network administration
  - Networking
  - Scripting
  - Sysadmin
  - System Administration

---
Visualizing an Azure deployment can be a bit tricky. This short Azure summary script is a good way to start though.

<!--more-->

I&#8217;ve been noodling around with an existing Azure deployment recently and wanted to get a quick tree view report of the networking elements. I didn&#8217;t find anything out there readily available so I put this quick script together. It is a tad simplistic but manages to capture some relationships pretty well I think. At the very least you should be able to quickly see if oddball things are being done like assigning NSGs to individual interfaces or gateway subnets. It will only show regions where you have active resources and just dumps all output to the screen (via Write-Output so you can pipe it wherever).

Here is a quick overview of what it will output:

<pre class="lang:powershell decode:true ">&lt;#
    Quick report of ARM based Azure networking that includes:

    - Location (region)
        - Virtual Networks (region based!)
            - Subnets
                - Associated NSGs
                - Associated Interfaces (VMs)
        - Network Security Groups (and rule counts)
                - Associated Subnets
        - Interfaces
        - Resource Groups
                - Associated Interfaces
                - Associated Availability Sets
#&gt;</pre>

You will need the AzureRM module and an ARM based deployment to get use from this. It would be cool to turn this into some graphviz charts (I&#8217;m looking at PSGraph for this if I can find the time).

Anyway, the script is [on github buried in my piles of other scripts][1] if anyone wants it.

 [1]: https://github.com/zloeber/Powershell/blob/master/Azure/Get-AzureRMNetworkSummary.ps1