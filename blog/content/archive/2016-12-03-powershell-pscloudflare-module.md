---
title: 'Powershell: PSCloudflare Module'
author: Zachary Loeber
type: post
date: 2016-12-03T16:27:51+00:00
url: /blog/2016/12/03/powershell-pscloudflare-module/
categories:
  - Powershell
  - System Administration
tags:
  - network administration
  - Powershell
  - Powershell Script
  - Sysadmin
  - System Administration

---
A well documented API without a PowerShell Module is like an itch begging to be scratched.

<!--more-->

I&#8217;ve been working on a re-architecture of an existing CDN solution into Cloudflare and had to add over 500 ip firewall rules to maintain parity with the existing solution. So I created this module to help accomplish the task. It started out pretty small but I think it is in a decent enough state to properly announce.

## Introduction

Firstly the original script I based this on can be located **[Here][1].** I believe due credit should be given for great work 🙂 As we all already know, PowerShell benefits from such a large community because of how easily one can take other&#8217;s work and expand upon it.

This project tears apart the original script and converts it into a proper module. In the process I&#8217;ve added a few improvements:

  * Implemented a proper build process ([PSModuleBuild][2])
  * Added documentation (via comment based help which PSModuleBuild converts to proper documentation via PlatyPS)
  * Generalized the functions
  * Added validation around some of the parameters

This project starts with a few functions I needed to add a large number of firewall rules but can be very easily added and expanded upon to suit your needs. The full documentation for the api can be found **[Here][3]**

## [][4]{#user-content-install.anchor}Install

You can use the installer script included with this project or, if you are using PowerShell 5.0 or greater simply run:

<pre class="lang:powershell decode:true">install-module pscloudflare</pre>

<span style="color: #eeeeee; font-size: 16px;">Example</span>

Here is a small example of some stuff you can do thus far.

    $Token = 'aaaaaaaaaabbbbbbbbbbccccccccccc1234552'
    $Email = 'jdoe@contoso.com'
    $Zone = 'contoso.com'
    
    # Connect to the CloudFlare Client API
    try {
        Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
        $Connected = $true
    }
    catch {
        $Connected = $false
    }
    
    if ($Connected) {
        # Add a firewall rule that challenges the visitor with a CAPTCHA 
        Add-CFFirewallRule -Item '192.168.1.0/24' -Notes 'Organization Block 1' -Target 'ip_range' -Mode:challenge -Verbose
    
        # List the firewall rules for the organization
        Get-CFFirewallRule -Verbose -ErrorAction Stop
    
        # Target the contoso.com zone (You can also simply pass the zone to the functions directly if you prefer)
        Set-CFCurrentZone -Zone $Zone -Verbose
    
        # Add a firewall rule that challenges the visitor with a CAPTCHA just for the contoso.com zone
        Add-CFFirewallRule -Item '10.0.0.1' -Notes 'Zone Block 1' -Target 'ip' -Mode:challenge -Verbose
    
        # List the firewall rules for contoso.com
        Get-CFFirewallRule -Verbose
    }
    

## [][5]{#user-content-contributing.anchor}Design Decisions

I&#8217;ve begun to notice a trend in the modules that I write. I know full well that I&#8217;m likely never going to encapsulate all of an API in my module so I try to code it in a way that makes it easier to expand in the future.

All the real work for invoking REST calls to the Cloudflare API is done by Invoke-CFAPI4Request. Prior to calling this function I use another function called Set-CFRequestData to populate a private variable (psobject) that will be used for the REST request. This will ensure that the most recent call data is always kept in a module variable that you can expose with Get-CFRequestData for troubleshooting and debugging purposes. This also makes it easier to log all API requests later on in a single function if I wanted to do so.

So even though I only created the functions for adding, listing, modifying, and removing firewall entries in Cloudflare it would be very easy for me (or others) to later on add any of the other Cloudflare API functionalities to this module.

I did something similar with my PSPaloAlto module but since all calls for it&#8217;s API are convoluted XML it is a different beast (but the same concept and module methodology apply).

## Links

[PSCloudFlare Github Project Page][6]

[PSCloudFlare on PowerShell Gallary][7]

[Cloudflare API documentation][3]

&nbsp;

 [1]: https://github.com/poshsecurity/PowerShell-CloudFlare-Tor-Whitelist
 [2]: https://github.com/zloeber/PSModuleBuild
 [3]: https://api.cloudflare.com/
 [4]: https://github.com/zloeber/PSCloudflare#install
 [5]: https://github.com/zloeber/PSCloudflare#contributing
 [6]: https://github.com/zloeber/PSCloudflare
 [7]: https://www.powershellgallery.com/packages/PSCloudFlare/0.0.3