---
title: Lync and UM Correlation with Powershell
author: Zachary Loeber
type: post
date: 2014-11-14T03:31:13+00:00
excerpt: This short function will parse AD for Lync enabled users and contacts and return a list of helpful information.
url: /blog/2014/11/13/lync-and-um-correlation-with-powershell/
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Lync
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Lync
  - Lync 2010
  - Lync 2013
  - Powershell
  - Sysadmin
  - System Administration
  - Windows

---
I&#8217;ve been working on an Exchange/Lync voice deployment lately and have found a new level of frustration for the lack of connectivity between the several voice components involved in turning up such a solution. That being said it is not very difficult to validate your deployment with a bit of Powershell.

There are a few necessary results to gather where I believe it can be easy to &#8216;miss&#8217; configuration steps when turning up or disabling users:

  * You enable a user for enterprise voice but forget to set their pin
  * You enable a user for enterprise voice but forget to UM enable their mailbox
  * You disable a previously lync enabled user (enterprise voice enabled or not) and forget to disable them in Lync
  * You enable a user for lync enterprise voice and um enable their mailbox but use the wrong extension.

These are just a few areas which can go awry in your environment either during the initial deployment or simply occur over time.

Here is a pretty simple function which I&#8217;ve put together which gathers info about all lync enabled accounts and contacts in the environment. As I extrapolate the Exchange UM information from AD attributes this function needs only be run on a Lync server or remote session. Here are the important bits broken down for those who are interested. If you just want the function and do not care for my ramblings you can download it either at the [technet gallery][1] or at my [new github repo][2].

First ensure that the lync modules are loaded and available (I use -Verbose:$false throughout the script as I only want my own verbose output to be shown, not verbose output from every lync cmdlet that runs). &#8216;Break&#8217; is a nice way to simply exit the function. As it is very unlikely this function will be called in a non-standalone manner this kind of non-terminating non-error throwing exit is fine. I throw out a warning at least.

<pre class="lang:powershell decode:true ">Import-Module Lync -ErrorAction:SilentlyContinue -Verbose:$false
if ((get-module lync) -eq $null)
{
Write-Warning "Get-LyncAndUMInfo: This script must be run on a lync server. Exiting!"
Break
}</pre>

I also break out the properties I&#8217;m going to be snatching from users and contacts in AD. This is not at all necessary but it makes for easier script reading later on. Contacts and users are not the same so were I to try and use the user properties against a contact when querying AD I&#8217;d get errors.

<pre class="lang:powershell decode:true ">$ADUserProperties = @('Name','GivenName','Surname','SamAccountName','mail','proxyAddresses','msRTCSIP-UserEnabled','msRTCSIP-Line','msExchUMEnabledFlags','msExchUMDtmfMap','msRTCSIP-PrimaryUserAddress')
$ADContactProperties = @('Name','GivenName','sn','mail','msRTCSIP-Line','msRTCSIP-PrimaryUserAddress')</pre>

I then go ahead and query AD for users which are lync enabled. I use an old school LDAP filter because I&#8217;m an old school type of guy (well that and opath filters do not always have the nuanced properties available for me to filter against).

<pre class="lang:powershell decode:true">Get-ADUser -Verbose:$false -LDAPFilter "(&(objectCategory=person)(objectClass=user)(msRTCSIP-UserEnabled=*))" -Properties $ADUserProperties | Where {($_.'msRTCSIP-UserEnabled' -ne $null) -and ($_.'msRTCSIP-UserEnabled' -ne $false)} | Foreach {</pre>

If the user is Lync enabled then they also have a primary user address so I use that to gather even more information about the account. I have to do this in order to get the PIN information as that is not held in AD from what I could tell. In fact, if you remove the -Verbose:$false from the Get-CSClientPinInfo and run this whole function with the -Verbose parameter you will see the Lync cmdlet spit out primary frontend server names that are getting queried for PIN info.

<pre class="lang:powershell decode:true">$LyncInfo = Get-CSUser -Verbose:$false $_.'msRTCSIP-PrimaryUserAddress' | Select SipAddress,EnterpriseVoiceEnabled,ExUmEnabled,DialPlan,VoicePolicy,PrivateLine, `
@{'n'='LyncPINSet';'e'={if ($_.EnterpriseVoiceEnabled){($_ | Get-CSClientPinInfo -Verbose:$false).IsPinSet} else {$false}}}</pre>

At this point since I already have the Lync info I go ahead and use it to determine if the user is UM enabled or not. If it is UM enabled I look for any proxyAddress starting with eum: followed by some digits and that is very likely an extension for the voicemail for this user.

<pre class="lang:powershell decode:true">if ($LyncInfo.ExUmEnabled)
{
$VoicemailExtension = $_.proxyAddresses | Where {$_ -match '^eum:(\d+).*$'} | Foreach {$Matches[1]}
}</pre>

With the information we have collected I create another object and return it. I use a bit of regex trickery to extract the telephone number and extension from the full LYnc URI while I&#8217;m at it.

<pre class="lang:powershell decode:true">$UserProps = @{
'Name' = $_.Name
'Type' = 'User'
'Enabled' = $_.Enabled
'FirstName' = $_.GivenName
'LastName' = $_.Surname
'Email' = $_.mail
'SipAddress' = $LyncInfo.SipAddress
'EnterpriseVoiceEnabled' = $LyncInfo.EnterpriseVoiceEnabled
'DialPlan' = $LyncInfo.DialPlan
'VoicePolicy' = $LyncInfo.VoicePolicy
'LyncPinSet' = $LyncInfo.LyncPinSet
'LyncTelURI' = $_.'msRTCSIP-Line'
'LyncPrivateLine' = $LyncInfo.PrivateLine
'LyncPhone' = if ($_.'msRTCSIP-Line' -match '^tel:(\+\d+).*$'){$matches[1]} else {$null}
'LyncPhoneExt' = if ($_.'msRTCSIP-Line' -match '^.*ext=(.*)$'){$matches[1]} else {$null}
'VoicemailEnabled' = $LyncInfo.ExUmEnabled
'VoicemailExtension' = $VoicemailExtension
}
New-Object PSObject -Property $UserProps</pre>

As it is very possible to have enterprise voice enabled contacts (that is all an autoattendant is in AD) we should probably get that information as well. I use Get-ADObject with another ldap filter to only look for contacts which are lync enabled.

<pre class="lang:powershell decode:true ">      Get-ADObject -Verbose:$false -LDAPFilter "(&(objectCategory=person)(objectClass=contact)(msRTCSIP-Line=*))" -Properties $ADContactProperties | Foreach {</pre>

I then return everything pretty much the same way as I did for user accounts except skip the voicemail and pin checking (though now that I&#8217;m writing this and thinking about it a pin check against enterprise voice enabled contacts may not be a bad idea&#8230;.).

<pre class="lang:powershell decode:true ">$UserProps = @{
'Name' = $_.Name
'Type' = 'Contact'
'Enabled' = $null
'FirstName' = $_.GivenName
'LastName' = $_.sn
'Email' = $_.mail
'SipAddress' = $_.'msRTCSIP-PrimaryUserAddress'
'EnterpriseVoiceEnabled' = $null
'DialPlan' = $null
'VoicePolicy' = $null
'LyncPinSet' = $null
'LyncTelURI' = $_.'msRTCSIP-Line'
'LyncPrivateLine' = $null
'LyncPhone' = if ($_.'msRTCSIP-Line' -match '^tel:(\+\d+).*$'){$matches[1]} else {$null}
'LyncPhoneExt' = if ($_.'msRTCSIP-Line' -match '^.*ext=(.*)$'){$matches[1]} else {$null}
'VoicemailEnabled' = $null
'VoicemailExtension' = $null
}
New-Object PSObject -Property $UserProps</pre>

With this function you can now create and export reports with some interesting information that may help in your deployment. Here are a few examples.

<pre class="lang:powershell decode:true ">$Users = Get-LyncAndUMInfo
$Users | Export-Csv AllLyncEnabledUserInfo.csv -NoTypeInformation
$Users | where {(-not $_.Enabled) -and $_.EnterpriseVoiceEnabled} | Export-Csv DisabledWithLyncNumbersStillAssigned.csv -NoTypeInformation
$Users | where {$_.Enabled -and $_.EnterpriseVoiceEnabled -and (-not $_.LyncPinSet)} | Export-Csv EnabledWithLyncNumbersAssignedButNoPINSet.csv -NoTypeInformation
$Users | where {$_.Enabled -and $_.EnterpriseVoiceEnabled -and (-not $_.VoicemailEnabled)} | Export-Csv EnabledWithLyncNumbersAssignedButNoVoicemailConfigured.csv -NoTypeInformation</pre>

As always, I welcome feedback and improvements. You can download the function in its entirety from the [technet gallery][1] or at my [new github repo][2].

&nbsp;

 [1]: https://gallery.technet.microsoft.com/Gather-All-Lync-and-UM-dc15739a
 [2]: https://github.com/zloeber/Powershell/blob/master/Lync/Get-LyncAndUMInfo.ps1