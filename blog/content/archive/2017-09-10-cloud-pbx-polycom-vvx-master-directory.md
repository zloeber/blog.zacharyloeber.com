---
title: 'Cloud PBX: Polycom VVX Master Directory'
author: Zachary Loeber
type: post
date: 2017-09-10T20:38:59+00:00
url: /blog/2017/09/10/cloud-pbx-polycom-vvx-master-directory/
categories:
  - Cloud PBX
  - Microsoft
  - Office 365
  - Powershell
  - Skype For Business
  - System Administration
  - Uncategorized
tags:
  - Cloud PBX
  - Office 365
  - Polycom
  - Powershell
  - Powershell Script
  - SIP
  - Skype For Business
  - System Administration
  - VVX

---
Reverse number lookup in Skype for Business online (cloud PBX) doesn&#8217;t give you much control. If you are deploying Polycom VVX phones you can get around this with a directory file.

<!--more-->

## Introduction

Migrating from an on premise PBX to pure Cloud PBX solution can be a bit painful. If you are smart you are at least choosing physical phones that don&#8217;t lock you down to a specific solution and are able to be bent to your will (er.. I mean customized to your environment). The Polycom VVX series phones are a prime candidate for such a migration for a number of reasons;

  1. They are widely supported across several different cloud and on premise PBX solutions, Skype for Business Online being one of them.
  2. They are extremely customizable
  3. They have several models with various price points and features but with the same underlying software on the same release cycle.

In this article I&#8217;ll cover a workaround I&#8217;ve put in place for a PBX migration to Skype for Business Online, or simply &#8216;Cloud PBX&#8217;.

## Setting the Stage

You have been tasked with eliminating infrastructure, including your aging PBX servers and equipment. As such, you have scoped out several Cloud based PBX solutions and have opted to go with Microsoft&#8217;s Cloud PBX solution. You already have all users on Office 365 and using Skype for Business. At this point you are moving forward with some user acceptance testing (UAT). Some user&#8217;s have been migrated to Cloud PBX from your on premise PBX. Their numbers were ported and Skype for Business has become their primary business phone. As already mentioned, Polycom VVX phones (specifically the 400 series model) have been selected to be provisioned for users.

## The Problem

Every solution starts with a problem. If you are a smart solutionist they are genuine business problems and aren&#8217;t simply fabricated to scratch an itch. In this case the problem manifested itself when testing end user experience for users in a hybrid state of migration. The main issue is that when users in Cloud PBX receive a call from user&#8217;s who are on-premise it will not say who they actually are. It didn&#8217;t matter that all the numbers in Active Directory were normalized and synced to o365 via AAD Sync either.

## The (partial) Solution

I came up empty handed researching the reverse number lookup methodology used in Cloud PBX. I&#8217;m not entirely certain if it is even possible to force RNL for different inbound calls but I do know that I can setup a directory of numbers when provisioning VVX phones. So at the very least these devices will show appropriate users for inbound calls from the on premise users. Additionally, I can add user&#8217;s mobile numbers and other special numbers for both reverse number lookup. Another bonus of doing this is that these numbers can also be searched via the phone&#8217;s built-in directory lookup for outbound calls. Sweet.

A holistic solution would also include possibly creating contacts for every user for special numbers (front desk, hunt groups, et cetera). I&#8217;m not willing to go that far though as this is a temporary situation until the migration to Cloud PBX is completed anyway.

Anyway, we need to create a &#8216;master&#8217; directory that will get loaded to the VVX phones to cover all of our users

## Source Numbers

In order to create the xml file used for the VVX devices I pull the following numbers from AD:

  * User telephone number (AD Property: telephonenumber)
  * User mobile number (AD Property: mobile)
  * User first name (givenname)
  * User last name (sn)

Additionally I&#8217;ll add in a few manual numbers for different hunt groups or other special numbers in the organization from a plain csv file with the following columns that align with the xml elements that eventually all of the directory entries will need to have:

  * ct – Contact (telephone number)
  * fn – First name
  * ln – Last name
  * lb &#8211;  Label

This csv file might look something like the following:

<table border="1" width="400" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="100">
      ct
    </td>
    
    <td valign="top" width="100">
      fn
    </td>
    
    <td valign="top" width="100">
      ln
    </td>
    
    <td valign="top" width="100">
      lb
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      +15555555555
    </td>
    
    <td valign="top" width="100">
      Front
    </td>
    
    <td valign="top" width="100">
      Desk
    </td>
    
    <td valign="top" width="100">
      Front Desk
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="100">
      +15555551111
    </td>
    
    <td valign="top" width="100">
      Help
    </td>
    
    <td valign="top" width="100">
      Desk
    </td>
    
    <td valign="top" width="100">
      Help Desk
    </td>
  </tr>
</table>

## Creating the File

Of course I use PowerShell to do this part of the solution, this is the kind of thing PowerShell excels at (and I excel at for that matter). Getting the data from AD can be done any number of ways. Some would use the ActiveDirectory module but since I&#8217;m crazy I have my own ADSI based module that I use called PSAD (PowerShell Active Directory). If you are on Windows 10 you can install it with the following

<pre class="lang:powershell decode:true">Install-Module PSAD</pre>

Otherwise you can download and install it on your system with the following:

<pre class="lang:powershell decode:true">iex (New-Object Net.WebClient).DownloadString(https://github.com/zloeber/PSAD/raw/master/Install.ps1)</pre>

The project site is <a href="https://github.com/zloeber/PSAD" target="_blank" rel="noopener">here</a> if you want more information (or want to contribute).

Anyway, you need to get your mobile and default telephone numbers from AD. As such, I &#8216;d highly recommend normalizing them all to the same format (starting with a +). I&#8217;ll leave that task to the reader but you can accomplish that with PSAD as well if you like.

Once you are ready you can create the directory xml file with the following script:

<pre class="lang:powershell decode:true " title="Create VVX Master Directory">try {
    import-module psad
}
catch {
    throw 'Unable to load PSAD!'
}

$ManualEntries = 'ManualEntries.csv'
$XMLOutputFile = '.\000000000000-directory.xml'
$XMLItemTemplate = @'
&lt;item&gt;
    &lt;ln&gt;@@LN@@&lt;/ln&gt;
    &lt;fn&gt;@@FN@@&lt;/fn&gt;
    &lt;ct&gt;@@CT@@&lt;/ct&gt;
    &lt;lb&gt;@@LB@@&lt;/lb&gt;
&lt;/item&gt;

'@
$XMLTemplate = @'
&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?&gt;
&lt;directory&gt;
&lt;item_list&gt;
@@ITEMS@@
&lt;/item_list&gt;
&lt;/directory&gt;
'@

# Get all accounts
$AllNumbers = get-dsuser -enabled -properties name,mobile,telephonenumber,samaccountname,givenname,sn -IncludeNullProperties | Where-Object {$null -ne ($_.telephonenumber + $_.mobile)}

# Import our manual entries if any exist
if (test-path $ManualEntries) {
    $Directory = import-csv .\ManualEntries.csv
}
else {
    $Directory = @()
}

# Define the mobile numbers
$AllNumbers | Where-Object {$null -ne $_.mobile} | ForEach-Object {
    $Directory += New-Object psobject -Property @{
        ln = $_.sn
        fn = $_.givenname
        ct = $_.mobile -replace '\.',''
        lb = "$($_.givenname) $($_.sn) (cell)"
    }
}

# Then the telephone numbers
$AllNumbers | Where {$null -ne $_.telephonenumber} | ForEach-Object {
    $Directory += New-Object psobject -Property @{
        ln = $_.sn
        fn = $_.givenname
        ct = $_.telephonenumber -replace '\.',''
        lb = "$($_.givenname) $($_.sn) (office)"
    }
}

# Create the directory xml file
$AllXMLItems = ''
$Directory | ForEach-Object {
    $AllXMLItems += $XMLItemTemplate -replace '@@LN@@',$_.ln -replace '@@FN@@',$_.fn -replace '@@CT@@',$_.ct -replace '@@LB@@', $_.lb
}

$XMLTemplate -replace '@@ITEMS@@', $AllXMLItems | Out-file -FilePath $XMLOutputFile -Encoding:utf8</pre>

## Implementation

Once you have run this file and created your directory file you will need to provision a phone with it. This is a bit easier said than done and there are restrictions. A good thread on the VVX directory files can be found [here][1]. Here is what you need to know in a nutshell though;

  1. The initial directory provisioning file is 000000000000-directory.xml
  2. As of firmware version 5.4 and above this file gets downloaded to the phone when it resets. After that you have to send [a special SIP notify signal][2] with check-sync event to the device to force it to download the file again.
  3. Any prior version of firmware only gets downloaded once, **ever**. After then only a factory reset will kick off a download of the directory file again.
  4. If the directory is changed on the device by the local user it will be saved individually as -directory.xml on the provisioning server and be merged with the master directory file when (or if) it is reprocessed.

So if you want to use a master directory like this you will need to have a functioning provisioning server to host it on. And if you want to use this more long term than initial deployment then you will have to schedule some manner of sending the SIP NOTIFY check-sync event to all your devices after updating the master directory file. And, of course, you will have to be running firmware 5.4+ on your devices.

That being said, if you want to script out sending the check-sync event I&#8217;ve gone ahead and added another function to my [PSVVX module][3] called &#8216;Send-VVXSIPNotify&#8217; for this very purpose. I recommend checking it out if you have a few free cycles.

 [1]: http://community.polycom.com/t5/VoIP/FAQ-How-can-I-create-a-local-directory-or-what-is-the/td-p/8216
 [2]: http://community.polycom.com/t5/VoIP/FAQ-Reboot-the-Phone-remotely-or-via-the-Web-Interface/td-p/4239
 [3]: https://github.com/zloeber/psvvx