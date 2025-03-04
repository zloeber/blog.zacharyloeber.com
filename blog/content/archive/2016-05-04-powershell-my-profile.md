---
title: 'PowerShell: My Profile'
author: Zachary Loeber
type: post
date: 2016-05-05T02:31:54+00:00
url: /blog/2016/05/04/powershell-my-profile/
categories:
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Powershell
  - Security
  - Sysadmin
  - System Administration
  - Windows

---
I&#8217;m always interested to see how other people setup their working environment or get things done. But rarely do I share my own environment. Since I&#8217;m putting the effort into pushing my scripting environment publicly to github I may as well explain a bit more about some of what I&#8217;ve setup.

<!--more-->

## Introduction

This is a collection of scripts, personal profile preferences that I pieced together from people much smarter (or at least more developer minded) than I. This is all for a personal need to be able to setup a standardized environment between my work and home PCs (or rebuild it quickly in either). As part of putting this collection together I created a few scripts worthy of their own mention. One of  the cooler scripts will create a code signing self-signed script and place it in the appropriate certificate stores. Using this cert and another included script you can sign and secure your profile for increased security.

## [][1]{#user-content-profile-description.anchor}Profile Description

I found and re-purposed Joel Bennett&#8217;s work for much of this part. His work is genius and I&#8217;m probably doing it an extreme disservice but I made several small changes and simplifications to it where I ran into issues. I re-purposed is environment.psm1 module as a general location for profile related functions (and fixed some path mangling issues I ran into for some reason). But truthfully 95% of the best parts of this environment are Joel&#8217;s script-craft.

Here is how my profile looks after immediately opening up a PowerShell prompt:

<div id="attachment_1599" style="width: 799px" class="wp-caption aligncenter">
  <img class="size-full wp-image-1599" src="/wp-content/uploads/2016/05/PowerShellProfile-Example.jpg?resize=586%2C297" alt="My PowerShell Profile" width="586" height="297" srcset="/wp-content/uploads/2016/05/PowerShellProfile-Example.jpg?w=789 789w, wp-content/uploads/2016/05/PowerShellProfile-Example.jpg?resize=300%2C152 300w, wp-content/uploads/2016/05/PowerShellProfile-Example.jpg?resize=768%2C389 768w" sizes="(max-width: 586px) 100vw, 586px" data-recalc-dims="1" />
  
  <p class="wp-caption-text">
    My PowerShell Profile
  </p>
</div>

### [][2]{#user-content-profile-configuration.anchor}Profile Configuration

There are two major components of the profile. One is a single file script module called environment.psm1. This module includes the lion&#8217;s share of important functions for the profile. This includes Joel&#8217;s &#8216;Set-Prompt&#8217; function that is used to retain command history across sessions among other things.

I&#8217;ve also included a number of one off scripts that are not used in the actual profile but are part of my personal essential scripts or used in the initial configuration of the profile. This includes:

  * Connect-ExchangeOnline.ps1  -> My own custom o365 connection script
  * Disconnect-ExchangeOnline.ps1
  * Load-PowerCLI.ps1 -> Vmware PowerCLI loader (if installed)
  * Load-Vagrant.ps1 -> Vagrant custom prompt module
  * Remove-ScriptSignature.ps1 -> Unsign scripts (used to clean up scripts before publishing online)
  * Set-ProfileScriptSignature.ps1  -> Resign the profile scripts
  * New-CodeSigningCertificate.ps1 -> Create a new self-signed code signing cert

The profile directory tree for my configuration looks like this:

  * `C:\Users\<user id>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
  * `C:\Users\<user id>\Documents\WindowsPowerShell\Scripts\*.ps1`
  * `C:\Users\<user id>\Documents\WindowsPowerShell\Modules\Environment\Environment.psm1`
  * `C:\Users\<user id>\Documents\WindowsPowerShell\Data\quotes.txt`

The profile itself automatically adds the &#8216;Scripts&#8217; directory to the local path so all you need to do to make a new script available to every session is drop it in this folder. The environment.psm1 module is the only outside script that is actually loaded by the profile so this needs to be signed if you are using script signing to harden the environment.

## [][3]{#user-content-installing.anchor}Installing

All you need to do is copy the contents of this repo into your WindowsPowerShell directory then optionally create a self-signed code signing certificate and run a script signing script I put together. I put together a quick install.ps1 file to do these tasks.

> **Note:** If I were you I&#8217;d just do this manually so you know nothing is getting accidentally overwritten. I&#8217;ve not heavily tested the install script!

&nbsp;

    iex (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/zloeber/PowerShellProfile/master/Install.ps1")

Once you have installed the basic components you can secure your profile a bit with a code signing certificate. An extra script or two I put together will do just that for ya if you like:

    . (Split-Path $Profile)\Scripts\New-CodeSigningCertificate.ps1
    
    . (Split-Path $Profile)\Scripts\Set-ProfileScriptSignature.ps1
    
    Set-ExecutionPolicy AllSigned

The script will look for a code signing certificate and attempt to create one if it doesn&#8217;t already exist. It is suggested to go ahead and do this if you aren&#8217;t using one already to sign your scripts. This will give you a few prompts as it tries to move the self-signed certificate to the appropriate store to be trusted.

Assuming that the self-signed code signing certificate gets created or already exists the next script will try to sign the environment.psm1 and Microsoft.PowerShell_profile.ps1 scripts to help prevent tampering of your profile. This really only becomes effective if you also set your local system to have its execution policy of AllSigned. Check your execution policy with this:

    Get-ExecutionPolicy -List

> **Note:** After the profile loads, it will set the Process scoped execution policy back to RemoteSigned!

## Updating or Changing Your Profile

If you change your profile script or the Environment.psm1 file just run the following to re-sign them again:

    . (Split-Path $Profile)\Scripts\Set-ProfileScriptSignature.ps1

## Profile Debugging

Press and hold either the left or right shift key while the profile is loading to see verbose details while the profile is loading.

## Random Quotes

Update the Data\quotes.txt file with whatever quotes you want as part of your random quote generation. Each quote should be on it&#8217;s own line. Nothing needs to be re-signed after updating this.

## Other Stuff

I&#8217;ve included my conemu.xml configuration file in this github repository. I use this with [Cmder][4], [the Hack font][5], and some transparency to great effect. This config file includes several different console session options (powershell as admin being one of them).

<div id="attachment_1598" style="width: 310px" class="wp-caption aligncenter">
  <img class="size-medium wp-image-1598" src="/wp-content/uploads/2016/05/Cmder.jpg?resize=300%2C122" alt="Some extra Cmder tab options." width="300" height="122" srcset="/wp-content/uploads/2016/05/Cmder.jpg?resize=300%2C122 300w, wp-content/uploads/2016/05/Cmder.jpg?w=471 471w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />
  
  <p class="wp-caption-text">
    Some extra Cmder tab options.
  </p>
</div>

## Conclusion

You can download individual components of this profile or the entire thing at the dedicated github repository found **[here][6]**.

I hope some one else finds this useful. I&#8217;m sure I&#8217;m missing all kinds of additional profile goodies I should be adding. I&#8217;d love to hear what others are finding to be indispensable in their PowerShell profiles as well!

 [1]: https://github.com/zloeber/PowerShellProfile#profile-description
 [2]: https://github.com/zloeber/PowerShellProfile#profile-configuration
 [3]: https://github.com/zloeber/PowerShellProfile#installing
 [4]: http://cmder.net/
 [5]: https://github.com/source-foundry/Hack-windows-installer/releases/tag/v1.1.2
 [6]: https://github.com/zloeber/PowerShellProfile