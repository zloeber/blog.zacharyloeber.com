---
title: 'PowerShell: Office 365 Group Based Licencing Cleanup'
author: Zachary Loeber
type: post
date: 2018-01-11T03:35:52+00:00
excerpt: 'PowerShell: Office 365 Group Based Licencing Cleanup'
url: /blog/2018/01/10/powershell-office-365-group-based-licencing-cleanup/
categories:
  - Azure
  - Microsoft
  - Office 365
  - Powershell
tags:
  - Azure
  - Office 365
  - Powershell
  - System Administration

---
A script to remove directly assigned licenses from user accounts if they overlap with group assigned licenses in Office 365.

<!--more-->

If you have deployed group-based licensing in Office 365 you may be left with a bunch of accounts that have licensing assigned both directly and via your license groups. If left this way then users that leave the organization may still consume a license in Office 365. This script will remove all directly assigned licenses only if they overlap with group assigned licenses.

There is an extra bit at the end that can be used to remove any leftover directly assigned licenses as well.

<pre class="lang:powershell decode:true">&lt;# 
    Extension of the following microsoft guide. 
    
    https://docs.microsoft.com/en-us/azure/active-directory/active-directory-licensing-ps-examples#get-all-users-with-license-errors-in-the-entire-tenant
#&gt;

function UserHasLicenseAssignedDirectly {
    #Returns TRUE if the user has the license assigned directly
    Param(
        [Microsoft.Online.Administration.User]$user,
        [string]$skuId
    )

    foreach($license in $user.Licenses) {
        #we look for the specific license SKU in all licenses assigned to the user
        if ($license.AccountSkuId -ieq $skuId) {
            #GroupsAssigningLicense contains a collection of IDs of objects assigning the license
            #This could be a group object or a user object (contrary to what the name suggests)
            #If the collection is empty, this means the license is assigned directly - this is the case for users who have never been licensed via groups in the past
            if ($license.GroupsAssigningLicense.Count -eq 0) {
                return $true
            }

            #If the collection contains the ID of the user object, this means the license is assigned directly
            #Note: the license may also be assigned through one or more groups in addition to being assigned directly
            foreach ($assignmentSource in $license.GroupsAssigningLicense) {
                if ($assignmentSource -ieq $user.ObjectId) {
                    return $true
                }
            }
            return $false
        }
    }
    return $false
}

function UserHasLicenseAssignedFromGroup {
    #Returns TRUE if the user is inheriting the license from a group
    Param(
        [Microsoft.Online.Administration.User]$user,
        [string]$skuId
    )

    foreach($license in $user.Licenses) {
        #we look for the specific license SKU in all licenses assigned to the user
        if ($license.AccountSkuId -ieq $skuId) {
            #GroupsAssigningLicense contains a collection of IDs of objects assigning the license
            #This could be a group object or a user object (contrary to what the name suggests)
            foreach ($assignmentSource in $license.GroupsAssigningLicense) {
                #If the collection contains at least one ID not matching the user ID this means that the license is inherited from a group.
                #Note: the license may also be assigned directly in addition to being inherited
                if ($assignmentSource -ine $user.ObjectId) {
                    return $true
                }
            }
            return $false
        }
    }
    return $false
}


function Get-UserLicenseSource {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [Microsoft.Online.Administration.User]$user
    )
    begin {
        $Users = @()
    }
    process {
        $Users += $User
    }
    end {
        Foreach ($User in $Users) {
            foreach($license in $user.Licenses) {
                New-Object -TypeName PSObject -Property @{
                    'UserPrincipalName' = $User.UserPrincipalName
                    'SkuID' = $license.AccountSkuId
                    'AssignedDirectly' = (UserHasLicenseAssignedDirectly -User $User -SkuID $license.AccountSkuId)
                    'AssignedFromGroup' = (UserHasLicenseAssignedFromGroup -User $User -SkuID $license.AccountSkuId)
                }
            }
        }
    }
}

Connect-MsolService

# Get all of our users with a license
$Users = Get-MsolUser -All | Where-Object {$_.isLicensed}

# Get all direct and group assigned licenses
$LicenseSources = $Users | Get-UserLicenseSource | Where-Object {$_.AssignedDirectly -and $_.AssignedFromGroup}

# Turn it into a hash to reduce our set-msollicense calls
$LicenseHash = $LicenseSources | Group-Object -Property UserPrincipalName -AsHashTable

# for each user with a direct and group assignment, remove the direct assignment.
Foreach ($user in $LicenseHash.Keys) {
    $SkusToRemove = $LicenseHash[$User].SkuID
    Set-MsolUserLicense -UserPrincipalName $User -RemoveLicenses $SkusToRemove
}

# you can also run this to remove all direct assignments (not assigned by a group):
$DirectOnlySources = $Users | Get-UserLicenseSource | Where-Object {$_.AssignedDirectly -and (-not $_.AssignedFromGroup)}

# Turn it into a hash to reduce our set-msollicense calls
$LicenseHash = $DirectOnlySources | Group-Object -Property UserPrincipalName -AsHashTable

Foreach ($user in $LicenseHash.Keys) {
    $SkusToRemove = $LicenseHash[$User].SkuID
    Set-MsolUserLicense -UserPrincipalName $User -RemoveLicenses $SkusToRemove
}</pre>

&nbsp;