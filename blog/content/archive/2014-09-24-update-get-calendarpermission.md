---
title: 'Update: Get-CalendarPermission'
author: Zachary Loeber
type: post
date: 2014-09-24T17:43:07+00:00
url: /blog/2014/09/24/update-get-calendarpermission/
categories:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - PSC
  - Security

---
Going through older code is a bit like looking through an old yearbook or photo album. If the pictures within are old enough you usually end up laughing at how little you recognize yourself and maybe even marvel a bit at how far you have come. This old function I wrote isn’t the worst of my code but I was still able to update it for measurable improvements.

<!--more-->

The previous script accepted only strings and performed get-mailbox against it. This version will take a mailbox object from the pipe as well as take a string. This should speed up results in some cases and is far easier to use inline. Here is a quick example getting all the non-standard calendar permissions for all mailboxes and exporting to csv:

<pre class="">get-mailbox | get-calendarpermission | where {@('anonymous','default') -notcontains $_.User} | export-csv -notypeinformation explicitcalendarperms.csv</pre>

* * *

* * *

Here is the function in its entirety.

<pre class="lang:powershell decode:true" title="Get-CalendarPermission">function Get-CalendarPermission {
    &lt;#
    .SYNOPSIS
    Retrieves a list of mailbox calendar permissions
    .DESCRIPTION
    Get-CalendarPermission uses the exchange 2010 snappin to get a list of permissions for mailboxes in an exchange environment.
    As different languages spell calendar differently this script first pulls the actual name of the calendar by using
    get-mailboxfolderstatistics and has proven to work across multi-lingual organizations.
    .PARAMETER Mailbox
    One or more mailbox names.
    .LINK
    http://zacharyloeber.com   
    .NOTES
    Last edit   :   09/24/2014
    Version     :   1.2.1 09/21/2014
                        - Removed log to file options and fixed a bunch of other issues.
                        - Enabled input of mailbox objects as well as strings
                    1.2.0 May 6 2013    :   Fixed issue where a mailbox name produces more than one mailbox
                    1.1.0 April 24 2013 :   Used new script template from http://blog.bjornhouben.com
                    1.0.0 March 10 2013 :   Created script
    Author      :   Zachary Loeber

    .EXAMPLE
    Get-CalendarPermission -MailboxName "Test User1" -Verbose

    Description
    -----------
    Gets the calendar permissions for "Test User1" and shows verbose information.

    .EXAMPLE
    Get-CalendarPermission -MailboxName "user1","user2" | Format-List

    Description
    -----------
    Gets the calendar permissions for "user1" and "user2" and returns the info as a format-list.

    .EXAMPLE
    (Get-Mailbox -Database "MDB1") | Get-CalendarPermission | Format-Table Mailbox,User,Permission

    Description
    -----------
    Gets all mailboxes in the MDB1 database and pipes it to Get-CalendarPermission. Get-CalendarPermission and returns the info as an autosized format-table containing the Mailbox,User, and Permission
    #&gt;
    [CmdLetBinding(DefaultParameterSetName='AsString')]
    param(
        [Parameter(ParameterSetName='AsString', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [string]$MailboxName,
        [Parameter(ParameterSetName='AsMailbox', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [Microsoft.Exchange.Data.Directory.Management.Mailbox]$MailboxObject
    )
    begin {
        $Mailboxes = @()
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AsString' {
                try { 
                    $Mboxes = @(Get-Mailbox $MailboxName -erroraction Stop)
                    $Mailboxes += $Mboxes
                }
                catch {
                    Write-Warning = "Get-CalendarPermission: $_.Exception.Message"
                }
            }
            'AsMailbox' {
               $Mailboxes += $MailboxObject
            }
        }
    }
    end {
        foreach($Mailbox in $Mailboxes)
        {
            # Construct the full path to the calendar folder regardless of the language
            $Calfolder = $Mailbox.Name + ':\' + [string](Get-MailboxFolderStatistics $Mailbox.Identity -folderscope calendar).Name
            # Get the permissions on the calendar
            $CalPerm = Get-MailboxFolderPermission $Calfolder
            $Results = @()
            foreach ($Perm in $CalPerm)
            {
                $Results += New-Object PSObject -Property @{
                                                              'Mailbox'=$Mailbox.Name
                                                              'User'=$Perm.User
                                                              'Permission'=$Perm.AccessRights
                                                          }
            }
            $Results
        }
    }
}</pre>

This function has been uploaded to technet as well.