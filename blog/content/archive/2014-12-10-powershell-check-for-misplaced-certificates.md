---
title: 'Powershell: Check For Misplaced Certificates'
author: Zachary Loeber
type: post
date: 2014-12-11T03:02:28+00:00
url: /blog/2014/12/10/powershell-check-for-misplaced-certificates/
categories:
  - Exchange 2013
  - Lync
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange 2013
  - Lync 2013
  - Microsoft
  - Powershell
  - PSC
  - Scripting
  - Security
  - Sysadmin
  - System Administration

---
Here is a script I absentmindedly put together one evening while power watching a TV series on Netflix with the wife. The general idea of this script is to check local machine, trusted root, and intermediate trusted root stores for misplaced or duplicate certificates.

<!--more-->

It is easy to get lax when deploying or maintaining Windows servers that require any kind of certificates to be installed. You may end up with trusted root certificates (aka self-signed issuing certs) in your intermediate trust store or vice versa. You may also have duplicated public certs across stores for whatever reason. Prior to Server 2012 and some of the more modern applications this really wasn’t an issue. As of late I’ve experiences some Lync 2013 oddities that make me think that it is about time to be more diligent with certificate placement and this script will help towards this end.

Anyway, the script makes educated guesses on incorrect cert placements and provides advice on what actions to take.

<pre class="lang:powershell decode:true "># Checks for possibly misplaced or duplicated certs
#
# *Check Trusted Root Store
# First get all trusted root certs in store
$rootcerts = Get-Childitem 'cert:\LocalMachine\root' -Recurse
# Check for certs which were not their own issuer (thus not a root certificate!)
$misplacedrootcerts = $rootcerts | Where-Object {$_.Issuer -ne $_.Subject}
Foreach ($cert in $misplacedrootcerts) {
    if (($intermediatecerts).thumbprint -contains $cert.thumbprint) {
        Write-Host -ForegroundColor:Yellow "Intermediate cert found duplicated in root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Delete certificate from trusted root store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
    else {
        Write-Host -ForegroundColor:Yellow "Intermediate cert found in root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Move certificate from trusted root store to intermediate store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
}

# *Check Trusted Intermediate Store
# First get all trusted intermediate certs in store
$intermediatecerts = Get-Childitem 'cert:\LocalMachine\CA' -Recurse | Where {$_.Subject -ne 'CN=Root Agency'}
# Check for certs which issued themselves (thus not an intermediate certificate!)
$misplacedintermediatecerts = $intermediatecerts | Where-Object {$_.Issuer -eq $_.Subject}
Foreach ($cert in $misplacedintermediatecerts) {
    if (($rootcerts).thumbprint -contains $cert.thumbprint) {
        Write-Host -ForegroundColor:Yellow "Trusted root cert found duplicated in intermediate cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Delete certificate from intermediate store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
    else {
        Write-Host -ForegroundColor:Yellow "Trusted root cert found in intermediate cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Move certificate from intermediate cert store to root cert store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
}

# *Check Local machine store
# First get all local machine certs in store
$mycerts = Get-Childitem 'cert:\LocalMachine\My' -Recurse
$myselfsignedcerts = $mycerts | Where-Object {$_.Issuer -eq $_.Subject}
$myrootduplicatedcerts = $mycerts | Where-Object {($rootcerts).thumbprint -contains $_.thumbprint}
$myintermediateduplicatedcerts = $mycerts | Where-Object {($intermediatecerts).thumbprint -contains $_.thumbprint}

Foreach ($cert in $myrootduplicatedcerts) {
    if (($myselfsignedcerts).thumbprint -contains $cert.thumbprint) {
        Write-Host -ForegroundColor:Yellow "Local machine certificate found duplicated in trusted root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Yellow "Certificate status: SELF-SIGNED (Possible trusted root authority)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Validate if the cert is a trusted root or simply self-signed and remove duplicate from one of the stores."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
    else {
        Write-Host -ForegroundColor:Yellow "Local machine certificate found duplicated in trusted root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Yellow "Certificate status: NOT SELF-SIGNED (Not a possible trusted root authority)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Delete this certificate from the trusted root store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
}

Foreach ($cert in $myintermediateduplicatedcerts) {
    if (($myselfsignedcerts).thumbprint -contains $cert.thumbprint) {
        Write-Host -ForegroundColor:Yellow "Local machine certificate found duplicated in intermediate root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Yellow "Certificate status: SELF-SIGNED (Possible trusted root authority)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Delete this certificate from the intermediate root store. Possibly move it to the trusted root store."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
    else {
        Write-Host -ForegroundColor:Yellow "Local machine certificate found duplicated in trusted root cert store - $($cert.Subject)"
        Write-Host -ForegroundColor:Yellow "Certificate status: NOT SELF-SIGNED (Not a possible trusted root authority)"
        Write-Host -ForegroundColor:Magenta "Recommended action: Validate if the cert is an intermediate root or a valid local machine cert and remove the duplicate from one of the stores."
        Write-Host -ForegroundColor:DarkMagenta '**Certificate Details **'
        Write-Host $cert
        Read-Host -Prompt ''
    }
}</pre>

&nbsp;