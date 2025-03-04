---
title: 'Exchange: Auto Batching 2013 Migrations'
author: Zachary Loeber
type: post
date: 2014-07-28T16:48:24+00:00
url: /blog/2014/07/28/exchange-auto-batching-2013-migrations/
categories:
  - Active Directory
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - PSC

---
Here is a quick script I put together for automatically creating Exchange 2013 mailbox migration batches. This is useful for the final stages of an Exchange 2013 upgrade among other things.

<!--more-->

### Introduction

It was pretty easy to batch up mailboxes with powershell for click-to-release migrations in the Exchange 2010 admin console. With Exchange 2013 the interface has changed to a concept called ‘batching’. With this change so too does your migration strategy have to change. I’ve put together a script (in a hurry) which allows you to specify several variables for automatically creating batches for migration purposes. You can use this script to create the CSVs and commands to import them. As this is just a quick hack I’m only going to post the code here for your convenience.

<pre class="lang:powershell decode:true  " title="Create-Exchange2013MigrationBatch"># Change these to suit your needs
$BatchSize = 50 # Maximum number of mailboxes per batch
$BadItemLimit = 10 # Maximum allowed bad items per batch
$BatchBaseName = 'MigBatchDB1andDB2' # Base file name for csv and import files
$SourceServer = 'Exchange2010Server' # target specific server to remove mailbox results for alreay migrated mailboxes
$SourceDatabases = @('MailDB01','MailDB02') # Target specific source mailbox databases
[string]$DestDBs = 'MDB01,MDB02' # Migrate the mailboxes to these databases (round robin)

# Don't change these
$CurrentPath = (pwd).Path
$CurrentBatch = 0
$CurrentBatchEmails = @()

$BatchCommand = @'
New-MigrationBatch -Local -Name @0@ -CSVData ([System.IO.File]::ReadAllBytes("@1@\@0@.csv")) -TargetDatabases @2@ -BadItemLimit @3@
'@
$BatchImportFileName = "$($BatchBaseName)_Import.txt"

$Mailboxes = Get-Mailbox -ResultSize Unlimited -Server $SourceServer 
$Mailboxes | Foreach { 
 if ($SourceDatabases -match $_.Database)
 {
 $CurrentBatchEmails += $_
 if ($CurrentBatchEmails.Count -ge $BatchSize)
 {
 $BatchName = "$($BatchBaseName)_$($CurrentBatch)"
 $tmpCommand = $BatchCommand -replace '@0@',$BatchName `
 -replace '@1@',$CurrentPath `
 -replace '@2@',$DestDBs `
 -replace '@3@',$BadItemLimit
 Out-File $BatchImportFileName -Append -InputObject $tmpCommand
 $CurrentBatchEmails | 
 Select @{n='EmailAddress';e={$_.PrimarySMTPAddress}} | 
 Export-Csv -NoTypeInformation "$($BatchName).csv"
 $CurrentBatch++
 $CurrentBatchEmails = @()
 }
 }
}

# Process the last batch of mailboxes if there are any
if ($CurrentBatchEmails.Count -gt 0)
{
 $BatchName = "$($BatchBaseName)_$($CurrentBatch)"
 [string]$tmpCommand = $BatchCommand -replace '@0@',$BatchName `
 -replace '@1@',$CurrentPath `
 -replace '@2@',$DestDBs `
 -replace '@3@',$BadItemLimit
 Out-File $BatchImportFileName -Append -InputObject $tmpCommand
 $CurrentBatchEmails | 
 Select @{n='EmailAddress';e={$_.PrimarySMTPAddress}} | 
 Export-Csv -NoTypeInformation "$($BatchName).csv"
}</pre>

This script will create multiple csv files for importing into the new-migrationbatch command. The commands for creating the batches will be dropped into a text file in the same directory for you to manually inspect and run. By default new migration batches do not automatically begin so they will just sit there in ECP waiting for someone to start the migrations.

I put this together in like 20 minutes so obviously use this at your own discretion.