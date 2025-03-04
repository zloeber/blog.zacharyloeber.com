---
title: 'PS Quickie: New-PIN'
author: Zachary Loeber
type: post
date: 2014-10-10T01:09:09+00:00
excerpt: Quick powershell script to pre-generate PINs.
url: /blog/2014/10/09/ps-quickie-new-pin/
categories:
  - Lync
  - Powershell
  - System Administration
tags:
  - Lync
  - Lync 2010
  - Lync 2013
  - Powershell
  - PSC

---
Setting a bunch of PINs for Lync devices is not difficult at all. Here is a script to pre-generate them should you find the need to do so. The function simply generates random digits between 0 and 9 and convert to a string. An exception is made for the first digit (as zeros are often not displayed in csv files when opened in excel) and only digits 1-9 are used.

<pre class="lang:powershell decode:true ">Function New-PIN ($pindigits)
{
    [string]$pin = ''
    1..$pindigits | foreach {
        switch ($_) {
            1 { $pin += [string](Get-Random -Minimum 1 -Maximum 10) }
            default { $pin += [string](Get-Random -Minimum 0 -Maximum 10) }
        }
    }
    $pin
}

#Example
$numberofpins = 10
$pindigits = 5
1..$numberofpins | Foreach {New-PIN $pindigits}</pre>