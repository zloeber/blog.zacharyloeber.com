---
title: 'PowerShell: PowerShellGet Helper Functions'
author: Zachary Loeber
type: post
date: 2016-12-21T21:21:12+00:00
url: /blog/2016/12/21/powershell-powershellget-helper-functions/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Microsoft
  - Powershell
  - Powershell Script
  - System Administration
  - Windows

---
With the PowerShell Gallery at your fingertips in PowerShell v5 you are able to find and install modules and scripts quickly. Here are a few helper functions you may want to add to your profile to help automate some of these tasks.

<!--more-->

I&#8217;ve been using Install-Module, Find-Module, and the other nifty commands in PowerShellGet for a while now. A few tasks which I&#8217;ve found helpful have morphed into their own scripts that I run fairly often. These helper functions have been published for a while buried in one of my github repos but I figured they are worthy enough for their own quick post. I keep these in a path of one-off scripts that gets loaded into my user&#8217;s environmental path variable within my PowerShell profile.

# Helper 1: Upgrade-InstalledModules.ps1

This simple script wraps around the Get-InstalledModule and Update-Module commands and attempts to upgrade modules installed on your system. Nothing fancy here.

<pre class="lang:powershell decode:true">&lt;#
.SYNOPSIS
    A small wrapper for PowerShellGet to upgrade all installed modules and scripts.
.DESCRIPTION
    A small wrapper for PowerShellGet to upgrade all installed modules and scripts.
.PARAMETER WhatIf
    Show modules which would get upgraded.
.EXAMPLE
    Upgrade-InstalledModules.ps1

    Description
    -------------
    Updates modules installed via PowerShellGet.
.NOTES
       Author: Zachary Loeber
       
       Requires: Powershell 5.0

       Version History
       1.0.0 - Initial release
#&gt;
[CmdletBinding()]
Param (
    [Parameter(HelpMessage = 'Show modules which would get upgraded.')]
    [switch]$WhatIf
)

try {
    Import-Module PowerShellGet
}
catch {
    Write-Warning 'Unable to load PowerShellGet. This script only works with PowerShell 5 and greater.'
    return
}

$WhatIfParam = @{WhatIf=$WhatIf}

Get-InstalledModule | Update-Module -Force @WhatIfParam
#Get-InstalledScript | Update-Script @WhatIfParam</pre>

# Helper 2: Remove-OldModule.ps1

As you begin to use install-module you will start to collect older versions of modules without even realizing it. This helper script will check a module for all the versions that are installed and attempt to remove all but the newest version.  When you run this without any module name it will loop through all installed modules. If you are worried about what it might try to uninstall use the -WhatIf flag.

<pre class="lang:powershell decode:true ">#Requires -Version 5

&lt;#
.SYNOPSIS
    A small wrapper for PowerShellGet to remove all older installed modules.
.DESCRIPTION
    A small wrapper for PowerShellGet to remove all older installed modules.
.PARAMETER ModuleName
    Name of a module to check and remove old versions of.
.EXAMPLE
    PS&gt; Remove-OldModules.ps1

    Removes old modules installed via PowerShellGet.

.EXAMPLE
    PS&gt; Remove-OldModules.ps1 -whatif

    Shows what old modules might be removed via PowerShellGet.

.NOTES
       Author: Zachary Loeber
       
       Requires: Powershell 5.0

       Version History
       1.0.0 - Initial release
#&gt;
[CmdletBinding( SupportsShouldProcess = $true )]
Param (
    [Parameter(HelpMessage = 'Name of a module to check and remove old versions of.')]
    [string]$ModuleName = '*'
)

try {
    Import-Module PowerShellGet
}
catch {
    Write-Warning 'Unable to load PowerShellGet. This script only works with PowerShell 5 and greater.'
    return
}
$WhatIfParam = @{}
$WhatIfParam.WhatIf = $WhatIf
Get-InstalledModule $ModuleName | Foreach-Object {
    $InstalledModules = get-module $_.Name -ListAvailable
    if ($InstalledModules.Count -gt 1) {
        $SortedModules = $InstalledModules | sort-object Version -Descending
        Write-Output "Multiple Module versions for the $($SortedModules[0].Name) module found. Highest version is: $($SortedModules[0].Version.ToString())"
        for ($index = 1; $index -lt $SortedModules.Count; $index++) {
            try {
                if ($pscmdlet.ShouldProcess( "$($SortedModules[$index].Name) - $($SortedModules[$index].Version)")) {
                    Write-Output "..Attempting to uninstall $($SortedModules[$index].Name) - Version $($SortedModules[$index].Version)"
                    Uninstall-Module -Name $SortedModules[$index].Name -MaximumVersion $SortedModules[$index].Version -ErrorAction Stop -Force
                }
            }
            catch {
                Write-Warning "Unable to remove module version $($SortedModules[$index].Version)"
            }
        }
    }
}</pre>

And that is really it. Enjoy!