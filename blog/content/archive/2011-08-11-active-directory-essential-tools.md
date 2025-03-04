---
title: 'Active Directory: Essential Tools'
author: Zachary Loeber
type: post
date: 2011-08-11T18:35:00+00:00
excerpt: During my many years of working with active directory I’ve used several tools. Here are some of the best that I’ve used which are not baked into windows. Good thing about this list is that most of these tools are fee! Another bonus is that most of the information gathering tools don’t require elevated rights as, by default, domain users have read-only access to active directory.
url: /blog/2011/08/11/active-directory-essential-tools/
wordbooker_options:
  - 'a:11:{s:18:"wordbook_noncename";s:10:"c14afc3180";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";s:20:"wordbook_comment_get";s:2:"on";s:17:"wordbook_new_post";s:1:"1";}'
wordbooker_extract:
  - 'During my many years of working with active directory I’ve used several tools. Here are some of the best that I’ve used which are not baked into windows. Good thing about this list is that most of these tools are fee! Another bonus is that most of the  ...'
categories:
  - Active Directory
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - 2008 R2
  - Active Directory
  - Microsoft
  - Powershell
  - System Administration
  - Windows

---
During my many years of working with active directory I’ve used several tools. Here are some of the best that I’ve used which are not baked into windows. Good thing about this list is that most of these tools are fee! Another bonus is that most of the information gathering tools don’t require elevated rights as, by default, domain users have read-only access to active directory.

## <!--more--> AD Info/AD Tidy

&nbsp;

### AD Info

This is a top notch information gathering tool that provides exportable reports for all kinds of AD related information. It actually checks every domain controller in your domain to ensure accuracy as well. This tool can provide an enormous amount of information about your forest which you  might have to script out otherwise.

&nbsp;

[Get AD Info here.][1]

### AD Tidy

From the same author as AD Info comes AD Tidy. Rather than re-hash the capabilities of this handy tool here is a list of features directly from the author’s site.

Features

  * Search for user or computer accounts
  * Search entire domain or select a specific OU
  * Specify alternate credentials to connect to domain with
  * Get account last logon information from all DCs or select specific DCs
  * Optionally only find accounts that have not logged on for a specified number of days
  * Can ping any computer accounts found, to help confirm if they are still active
  * Exclude or include disabled accounts, or only find disabled accounts
  * Exclude specific account names from the search results
  * Save search settings to file so that you can reload them whenever you want
  * Works with domains that you are not a member of (assuming you provide valid credentials)
  * Help buttons within the application explain what each setting is for

For any accounts that are found in the search, you can perform one of the following actions:

  * Disable
  * Enable
  * Delete
  * Move To Another OU
  * Set Description
  * Set Expiration Date
  * Add To Group
  * Remove From Group
  * Remove From All Groups
  * Hide From Exchange Address Lists (not tested with Exchange 2010 yet)
  * Delete home drive
  * Export Details To CSV

[Get AD Tidy here.][2]

&nbsp;

This author has a few other handy tools you may want to check out as well ([AD Photo Edit][3], [Group Manager][4], [Get Group Membership][5])

&nbsp;

## AD Explorer

Sysinternals made this little gem of a free utility. It is basically active directory users and computers on steroids. You can use AD explorer to save favorite locations, take snapshots, and dig into the innards of AD in a way that is similar to adsiedit. The snapshots can be compared and browsed offline.

[Get AD Explorer here.][6]

## Oldcmp.exe

[Joeware][7] makes a bunch of really nice free command-line driven tools for AD but oldcmp.exe is one of my favorites. You use oldcmp.exe to generate, and optionally take actions against, old computers and users.

Here is a good sample script you can use and modify to suit your needs. It assumes that you are generating reports in a “Reports” directory residing with the oldcmp.exe executable. Pay special attention to the fact that we are excluding cluster names from the results (-excldn cluster01;cluster02). Cluster names are virtual and don’t ever really get logged on to. You will also have to change the ldap paths to match your organizational needs.

<pre>REM --- This script can report and move old Servers within AD</pre>

<pre>REM --- MOVE OLD Servers (Password older than 90 days) ---</pre>

<pre>REM - Find computer accounts with passwords older than 90 days</pre>

<pre>REM - If you just want a report of old workstations run this</pre>

<pre>oldcmp -report -nohtmlheader -file ".\Reports\old_servers.html" -llts -sort lltsAge -b "ou=Servers,ou=Computers,ou=North America,dc=corp,dc=contoso,dc=local"</pre>

<pre>REM – Remove REM on next line to MOVE old servers to another OU and generate a report</pre>

<pre>REM oldcmp -nohtmlheader -file ".\Reports\old_servers.html" -rsort LLTS -b "ou=Servers,ou=Computers,ou=North America,dc=corp,dc=contoso,dc=local" -move -newparent "ou=Computers,ou=Inactive Accounts,ou=North America,dc=corp,dc=contoso,dc=local" -nodc -norefer –unsafe –forreal</pre>

If you wanted to email the reports to some versioned email enabled sharepoint document libarary you [can use blat.exe][8] in a batch file that looks like this:

<pre>@echo off</pre>

<pre>blat - -body " " -to "ADmaintenance@sharepoint.internal" -f "adreport@na.corp.contoso" -s "Old Servers" -serverexchangeserver.na.corp.contoso -log blat.log -timestamp -attacht .\Reports\old_servers.html</pre>

&nbsp;

[Get oldcmp.exe here.][9]

&nbsp;

## Microsoft Active Directory Topology Diagrammer

This is a handy tool to have if you are becoming familiar with a new forest. It will connect with a global catalog server or domain controller and collect information about the forest and visually map it out in a visio diagram. The diagrams are often a total mess initially but nothing that a bit of manual tweaking cannot resolve. As an added bonus it can also do some exchange mapping if you like (not really valid in Exchange 2010 though).

[Get ADTD here.][10]

## Quest AD-PKI Powershell Cmdlts

Although the included Microsoft AD cmdlts are fairly decent they never quite got to the level of usefulness as the Quest AD powershell cmdlts. If you have ever had to do mass updates or data retrieval from AD you know that the baked in command line programs Microsoft provides are available; ldifde.exe or csvde.exe. But these require the use of ldap filters to get any filtered information. Besides the fact that ldap filters are going the path of the do-do bird (well maybe not but it sure feels that way with exchange 2010 moving to opath filters) I find them to be needlessly complex. That and I’ve become quite enamored with powershell from using it so much for Exchange 2010 related tasks.

Here is a list of powershell (both quest and non-quest specific) and command line snippets which you might find handy to have:

**_Get a list of all users and list their permission inheritance setting_**

<pre>Get-QADUser -SizeLimit 0 | Select-Object Name,@{n='IncludeInheritablePermissions';e={!$_.DirectoryEntry.PSBase.ObjectSecurity.AreAccessRulesProtected}}</pre>

**_Get a list of all users and list those without permission inheritance setting set_**

<pre>Get-QADUser -SizeLimit 0 | Select-Object Name,@{n='IncludeInheritablePermissions';e={!$_.DirectoryEntry.PSBase.ObjectSecurity.AreAccessRulesProtected}} | Where {!$_.IncludeInheritablePermissions}</pre>

**_Set Permission Inheritence on all Users_**

<pre>Get-QADUser -SizeLimit 0 | Set-QADObjectSecurity -LockInheritance</pre>

**_Get Computers in OU with Descriptions (use –Service to reference specific forests)_**

<pre>Get-QADComputer -Service corp.contoso.local -SearchRoot "Ou=SomeOtherOU,OU=SomeOU,DC=corp,DC=contoso,DC=local" -Description "*" | Select-Object Name, Description | Export-Csv -NoTypeInformation C:\Temp\emea5_systems.csv</pre>

**_Get Computers in OU, Parse Descriptions for User Names, and Try to Enumerate Logon ids._**

**_(Note: the -Service is used to get past a limitation of the qwest AD powershell commandlets. This is also rather slow)_**

<pre>Get-QADComputer -Service corp.contoso.local -SearchRoot "Ou=SomeOtherOU,OU=SomeOU,DC=corp,DC=contoso,DC=local"  | Where {$_.Description} | Select-Object Name,Description,@{name="SAMname";expression={(get-qaduser -Service  corp.contoso.local -Name $_.Description).SAMAccountName}},@{name="NewName";expression={(get-qaduser -Service  corp.contoso.local -Name $_.Description).PrimarySMTPAddressPrefix}} | Export-Csv "c:\Temp\computer-logons.csv" -NoTypeInformation</pre>

**_Set 2008 R2 AD forest mode_**

<pre>Import-Module Active Directory</pre>

<pre>Set-ADForestMode domain.tld  Windows2008R2Forest</pre>

&nbsp;

**_Enable Recycle Bin in 2008 R2_**

<pre>Enable-ADOptionalFeature –Identity 'CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration, DC=corp,DC=contoso, DC=local' -Scope ForestOrConfigurationSet -Target 'corp.contoso.local'</pre>

&nbsp;

**_Restore Deleted AD Object_**

<pre>Get-ADObject -Filter {displayName -eq "Some user"} -IncludeDeletedObjects | Restore-ADObject</pre>

&nbsp;

**_Get All Group Memberships For A User_**

<pre>$sUser= Get-QADUser -Service "corp.contoso.local" test.user; foreach ($grp in $sUser.memberof) {Get-QADGroup $grp | select GroupName,Domain,GroupScope,GroupType};</pre>

**_Assign a CSV of User Properties to Users Skipping Empty Fields_**

<pre>foreach ( $record in (Import-Csv c:\update.csv)) {</pre>

<pre>  $command = "Set-QADUser $($record.samAccountName)"</pre>

<pre>  foreach ( $attr in</pre>

<pre>   (Get-Member -InputObject $record -MemberType NoteProperty) ) {</pre>

<pre>     $value = $record.($attr.Name)</pre>

<pre>     if ( $value -and ( $attr.Name -ne 'samAccountName' ) ) {</pre>

<pre>      $command += " -$($attr.Name) $value"</pre>

<pre>     }</pre>

<pre>  }</pre>

<pre>  Invoke-Expression $command</pre>

<pre>}</pre>

&nbsp;

[Get Quest AD-PKI Cmdlets here.][11]

&nbsp;

## PowerGui

If you have already installed the Quest AD-PKI Cmdlets then you may as well install PowerGui as well as it can use them for pulling up all kinds of info in your environment and automatically generate scripts for you as well! Just make sure to select the AD powerpack option when installing PowerGUI.

[Download PowerGUI here.][12]

 [1]: http://www.cjwdev.co.uk/Software/ADReportingTool/Index.html
 [2]: http://www.cjwdev.co.uk/Software/ADTidy/Info.html
 [3]: http://www.cjwdev.co.uk/Software/ADPhotoEdit/Info.html
 [4]: http://www.cjwdev.co.uk/Software/GroupMan/Info.html
 [5]: http://www.cjwdev.co.uk/Software/GetGroupMembership/Info.html
 [6]: http://technet.microsoft.com/en-us/sysinternals/bb963907
 [7]: http://www.joeware.net/freetools/index.htm
 [8]: http://www.blat.net/
 [9]: http://www.joeware.net/freetools/tools/oldcmp/index.htm
 [10]: http://www.microsoft.com/download/en/details.aspx?id=13380
 [11]: http://www.quest.com/powershell/activeroles-server.aspx
 [12]: http://powergui.org/index.jspa