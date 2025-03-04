---
title: Audit User Profile Folders With Powershell
author: Zachary Loeber
type: post
date: 2013-06-21T18:46:09+00:00
url: /blog/2013/06/21/audit-user-profile-folders-with-powershell/
categories:
  - Active Directory
  - Active Directory
  - Microsoft
  - Networking
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Microsoft
  - network administration
  - Networking
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
This function will aggregate sub-folders within a folder on a server and attempt to associate them with user IDs within a domain and provide additional information. This script can also be used to move folders for disabled or non-existent accounts.

<!--more-->

## Description

If you find yourself needing to go through a load of old user profiles this function may be able to help. This function goes through a specified directory and can perform the following:

  * Look up user ids in AD which match the folder names and determine if they are enabled or even exist.
  * Move profiles where users are disabled to another folder
  * Move profiles where users are not found to another folder
  * Report on the size of each profile folder
  * Report on the most recently updated file within each profile folder
  * Report if errors were found accessing any files within a profile folder

## Version

Version : 1.0.0 June 21th 2013
  
&#8211; First release

## Notes

I only included the ability to move folders to the local volume. Also, deeply nested folders may throw errors. These are both shortcomings/limitations of the built in move-item powershell command and .NET. I tinkered with using powerrobocopy.ps1 instead but ultimately left it out to remove a dependency.

I use the lastlogontimestap AD property to determine the last logon for a user. If you are on a pre-2003 AD infrastructure then this script may not be for you (In fact, this decade may not be for you, upgrade your domain already!).

## Conclusion

This script may be a good starting point for a user profile migration move or possibly a data archiving initiative within your organization. The function is currently limited to a single server and folder but can easily be expanded upon (that is the nature of free scripts after all!)

## Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/scriptcenter/Audit-User-Profile-Folders-4d13ef94
 [2]: /wp-content/uploads/2013/06/Get-UserProfileShareFolderAudit.ps1