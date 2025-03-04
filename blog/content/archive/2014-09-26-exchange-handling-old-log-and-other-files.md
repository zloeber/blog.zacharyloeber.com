---
title: 'Exchange: Handling Old Log and Other Files'
author: Zachary Loeber
type: post
date: 2014-09-26T19:41:59+00:00
excerpt: Use powershell to managed out of control Exchange log files.
url: /blog/2014/09/26/exchange-handling-old-log-and-other-files/
categories:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - IIS
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - PSC
  - Sysadmin
  - System Administration

---
In Exchange old logs can really build up fast. Not database transaction logs but rather temporary transport, client access, IIS, and other debug related crap that typically default to locations either on your system drive or Exchange install path. Of course, Powershell scripting can provide a decent solution for this problem.

## Introduction

More than any other version, Exchange 2013 seems to like logging information to disk. By default, much of what gets logged will not auto-rotate (or if it does, it happens infrequently) either so you end up with this slow ticking time-bomb in your environment.

I’ve been using a few one liners for a while now to pare down old logs and such from Exchange 2013 servers. In a pinch this still works just fine:

<pre class="lang:powershell decode:true">$TransportTemp = "$($env:ExchangeInstallPath)TransportRoles\Data\Temp" 
$ExchangeLogging = "$($env:ExchangeInstallPath)Logging" 
Get-ChildItem $TransportTemp | gci -Recurse | ? LastWriteTime -lt (Get-Date).AddDays(-14) | Remove-Item 
Get-ChildItem 'C:\inetpub\logs',$ExchangeLogging -Directory | gci -Include '*.log','*.blg' -Recurse | ? LastWriteTime -lt (Get-Date).AddDays(-14) | Remove-Item</pre>

The down side to this quick approach is that you have to run this directly on each server and there is no real reporting on how much space you are saving. It also requires knowing where some of the logs are ahead of time (c:\inetpub). Finally, this only gets a small subset of the logs most likely to balloon out of control.

In any case it is all very manual and is just a quick hack. So I finally decided to put an official script together instead. And, as I tend to do with scripts, I probably over-engineered the solution. But it works for me and may be valuable to you even if you are not explicitly using it for Exchange.

## Interesting Script Notes

One of the issues with existing scripts for cleaning out exchange logs is that they are based around the files being located in the same locations on every server. I get around this with some psremoting (invoke-command) to gather web logging locations and exchange install paths.

> Note: Enable remoting with the following in a cmd prompt:
> 
> winrm quickconfig

Since I’m already using psremoting to get log file locations I also use it again for some of the folder size reporting to get some performance boosts. (Remotely enumerating several hundred files can take a very long time in powershell but you can get around this with Scripting.FileSystemObject run locally on a system). This only makes sense if you are looking for entire folder size information. If you are filtering folders by file type or date for utilization there is no real choice but to use builtin powershell looping.

Here is the function I put together for getting the folder size with all of these factors. I added in some logic at the very beginning to determine if the path is local or remote as well.

<pre class="lang:powershell decode:true">function Get-FolderSize {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='Directory path')]
        [string]$path,
        [Parameter(HelpMessage='Only include data older than this number of days in calculation. Ignored if set to zero.')]
        [int]$days = 0,
        [Parameter(HelpMessage='Only include files matching this criteria.')]
        [string[]]$criteria = '*',
        [string]$ComputerName,
        [switch]$UseRemoting,
        [System.Management.Automation.Runspaces.PSSession]$Session = $null

    )
    $InvokeSplat = @{}

    $LocalPath = $false
    if ($path -like '*:*')
    {
        $LocalPath = $true
    }
    elseif ($path -like '\\*')
    {
        if ($path -match '\\\\(.*?)\\')
        {
            $ComputerName = $Matches[1]
        }
        else
        {
            throw 'Get-FolderSize: Invalid Path!'
        }

        $IPAddresses = [net.dns]::GetHostAddresses($env:COMPUTERNAME) | Select-Object -ExpandProperty IpAddressToString
        $HostNames = $IPAddresses | ForEach-Object {
            try {
                [net.dns]::GetHostByAddress($_)
            } 
            catch {}
        } | Select-Object -ExpandProperty HostName -Unique
        $LocalHost = @('', '.', 'localhost', $env:COMPUTERNAME, '::1', '127.0.0.1') + $IPAddresses + $HostNames
        if ($LocalHost -contains $ComputerName)
        {
            $LocalPath = $true
        }
    }
    
    if (Test-Path $path)
    {
        if (($LocalPath -or $UseRemoting) -and (($days -eq 0) -and ($criteria -eq '*')))
        {   # using fso (faster)
            # convert to local pathname first
            $path = $path -replace '\$',':' -replace '(^\\\\.*?\\)',''
            if ($UseRemoting)
            {
                if ($Session -ne $null)
                {
                    $InvokeSplat.Session = $Session
                }
                else
                {
                    $InvokeSplat.ComputerName = $ComputerName
                }
                Write-Verbose "Get-FolderSize: Using remoting with FileSystemObject on $ComputerName to enumerate $path..."
                $RemoteCMDString = "`$objFSO = New-Object -com  Scripting.FileSystemObject; `$objFSO.GetFolder(`'$path`').Size"
                $RemoteCMD = [scriptblock]::Create($RemoteCMDString)
                return $(Invoke-Command @InvokeSplat -ScriptBlock $RemoteCMD)
            }
            else
            {
                Write-Verbose "Get-FolderSize: Using FileSystemObject on localhost to enumerate $path..."
                $objFSO = New-Object -com  Scripting.FileSystemObject
                return $objFSO.GetFolder($path).Size
            }
        }
        else
        {
            # pure powershell (slower)
            Write-Verbose "Get-FolderSize: Using powershell to enumerate $path..."
            $LastWrite = (Get-Date).AddDays(-$days)
            $colItems = (Get-ChildItem -Recurse $path -Include $criteria -ErrorAction:SilentlyContinue | 
                            Where {$_.LastWriteTime -le "$LastWrite"} | 
                                Measure-Object -property length -sum)
            return $colItems.sum
        }
    }
    else
    {
        Write-Warning 'Get-FolderSize: Invalid Path!'
    }
}</pre>

I’ve wrapped up a number of additional functions with this folder size function in a single script with some predefined scenarios to make the script easier to use. The scenarios included are:

> <span style="text-decoration: underline;">RetrieveValidFolders</span> – Gather a list of valid Exchange logging and temp folders which you can use to pipe into other functions to perform custom actions.
> 
> <span style="text-decoration: underline;">ReportOldLogSize</span> &#8211; Gather a list of valid Exchange logging and temp folders and also enumerate their total size as well as the size of all the old logs that exist before the specified number of days. This includes message tracking logs.
> 
> <span style="text-decoration: underline;">DeleteOldLogs</span> – Attempt to delete all logs which are older than the number of days specified. This does NOT include message tracking logs.
> 
> <span style="text-decoration: underline;">DeleteOldLogsTestRun</span> – Same as DeleteOldLogs but without actually deleting anything (adds –WhatIf to all Remove-Item commands). This does NOT include message tracking logs.

These scenarios work in concert with the available parameters to give you more control of which servers will be targeted and how many days worth of logs you want to keep.

> <span style="text-decoration: underline;">DaysToKeep</span> – The number of days of log files you wish to retain.
> 
> <span style="text-decoration: underline;">ServerFilter</span> – Target specific Exchange 2013 servers. By default all (*) servers in the environment are targeted.
> 
> <span style="text-decoration: underline;">FileTypes</span> &#8211; The types of old files to report upon or delete. By default this is \*.log and \*.blg. You may want to manually set this to * instead to force psremoting and fast directory size enumeration.

It should be noted that I&#8217;m not even trying to rotate or save the old files with this script. This is was written to report upon and optionally delete old logs and other temporary files related to Exchange 2013. Obviously take care with what you delete in your own environment.

The default file types which will be reported upon or cleaned up are \*.log and \*.blg (daily performance counter files). Optionally you may want to include *.bak to get some of the perfmon counter load backup files as well.

## Examples

Here is a report of logs older than 14 days. Note that the message tracking logs are included here but are not part of the actual deletion scenarios unless you make manual modifications (add in your own scenario).

<pre class="lang:powershell decode:true">$oldlogs = .\Manage-ExchangeDirectories.ps1 -DaysToKeep 14 -Scenario:ReportOldLogSize -Verbose 
$oldlogs | ft -auto</pre>

[<img style="margin: 5px; display: inline; background-image: none;" title="image" src="/wp-content/uploads/2014/09/image_thumb.png?resize=551%2C234" alt="image" width="551" height="234" border="0" data-recalc-dims="1" />][1]

Here is a more complicated example which targets one specific server. The following lines will gather only total folder size information via psremoting (thus speeding up processing time) first. We then delete any \*.log, \*.blg, and *.bak files older than 14 days. Finally we generate a report on the folders previous vs. its current size. Again notice that I don&#8217;t futz with message tracking at all. But since it is included in the report aspect of this script the folder for message tracking actually goes up in size!

<pre class="lang:powershell decode:true">$logdirsize = .\Manage-ExchangeDirectories.ps1 -DaysToKeep 0 -FileTypes '*' -Scenario:ReportOldLogSize -ServerFilter 'EXCH2' -Verbose
.\Manage-ExchangeDirectories.ps1 -Scenario:DeleteOldLogs -DaysToKeep 14 -ServerFilter 'EXCH2' -Verbose -FileTypes '*.log','*.blg','*.bak'
$newlogdirsize = .\Manage-ExchangeDirectories.ps1 -DaysToKeep 0 -FileTypes '*' -Scenario:ReportOldLogSize -ServerFilter 'EXCH2' -Verbose
$logdirsize | %{ $logdir = $_; $newlogdir = $newlogdirsize | where {$_.Description -eq $logdir.description}; New-Object psobject -Property @{'Log' = $logdir.Description;'OldSize' = $logdir.TotalSize;'NewSize' = $newlogdir.Totalsize}}|Select log,Oldsize,Newsize | ft -auto</pre>

[<img class="aligncenter size-medium wp-image-1274" src="/wp-content/uploads/2014/09/SizeDiffReport.jpg?resize=300%2C90" alt="SizeDiffReport" width="300" height="90" srcset="/wp-content/uploads/2014/09/SizeDiffReport.jpg?resize=300%2C90 300w, /wp-content/uploads/2014/09/SizeDiffReport.jpg?w=529 529w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]

## Conclusion

This should be a pretty easy script to schedule via task scheduler if you so desired. To [download the script in its entirety visit the technet gallery.][3]

 [1]: wp-content/uploads/2014/09/image.png
 [2]: /wp-content/uploads/2014/09/SizeDiffReport.jpg
 [3]: http://gallery.technet.microsoft.com/Exchange-Manage-Log-36ced742