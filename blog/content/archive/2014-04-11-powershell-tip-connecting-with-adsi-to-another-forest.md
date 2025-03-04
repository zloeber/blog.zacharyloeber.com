---
title: Powershell Tip – Connecting With ADSI to Another Forest
author: Zachary Loeber
type: post
date: 2014-04-11T21:17:43+00:00
excerpt: Using a bit of Powershell and ADSI it is pretty easy to connect to another forest. Finding out how to do so is not very clear though.
url: /blog/2014/04/11/powershell-tip-connecting-with-adsi-to-another-forest/
categories:
  - Active Directory
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Active Directory
  - ADSI
  - Powershell
  - PSC

---
Using a bit of Powershell and ADSI it is pretty easy to connect to another forest. Finding out how to do so is not very clear though. Here is what I came up with to accomplish this task.
  
<!--more-->

### Introduction

A fellow scripter, MVP, and Powershell hero, Francois-Xavier posted [on his blog an article][1] on utilizing alternate credentials against AD. In this scenario he is connecting to AD from a computer which is joined to the same domain/forest he is attempting to use the alternate credential against. This is an ideal example for situations where you need to manage your domain with a separate administrative account than your daily use account (this is best practice actuallly). Since the machine is already joined to the domain, getting the starting bits of information you need to further connect with alternate credentials is fairly trivial. Francois-Xavier gave the following example:

<pre class="lang:powershell decode:true"># Get the current domain
$DomainDN = $(([adsisearcher]"").Searchroot.path)</pre>

This does not work for connecting to a remote forest though. If you want to connect to a remote forest you have to add some additional components beyond the alternate credentials. Firstly, you will need to connect to a domain controller in order to extrapolate the rest of the connection information. To do this you can supply the IP address or name of a domain controller in the forest you which to connect to along with your remote forest credentials. Here is one way this might be done.

<pre class="lang:powershell decode:true">$ServerName = ''
$UserName = 'domain\user'
$Credential = Get-Credential -Credential $UserName

$DomainEntry = New-Object -TypeName System.DirectoryServices.DirectoryEntry "LDAP://$ServerName" ,$($Credential.UserName),$($Credential.GetNetworkCredential().password)
$DomainName = $DomainEntry.name

# Example search against remote domain (finding all group objects)
$Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
$Searcher.Filter = "(objectCategory=Group)"
$Searcher.SizeLimit = '1000'
$Searcher.SearchRoot = $DomainEntry
$Searcher.FindAll()

# Create domain level connection
$DomainContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $DomainName)
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($DomainContext)

# Create forest level connection
$ForestContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext("Forest", $domain.forest)
$forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($ForestContext)</pre>

There is not much to the code really. I suppose the password extraction from the credential object is nifty but the rest is just standard powershell.

 [1]: http://www.lazywinadmin.com/2013/10/powershell-using-adsi-with-alternate.html