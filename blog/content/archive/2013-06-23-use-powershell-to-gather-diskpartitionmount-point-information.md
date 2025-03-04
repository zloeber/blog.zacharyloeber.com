---
title: Use Powershell to Gather Disk/Partition/Mount Point Information
author: Zachary Loeber
type: post
date: 2013-06-24T04:41:01+00:00
url: /blog/2013/06/23/use-powershell-to-gather-diskpartitionmount-point-information/
categories:
  - Microsoft
  - Networking
  - Powershell
  - Storage
  - System Administration
tags:
  - 2008 R2
  - Microsoft
  - Monitoring
  - network administration
  - Networking
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
I put together a function for remotely gathering Windows disk information. This was specifically written to accommodate alternate credentials. This script also accounts for the glaring disconnect between win32\_Volume and win32\_DiskDrive within WMI.

<!--more-->

## Description

I was looking at powershell functions which gather remote disk information via WMI and was unable to find any which return both information about local disks/partitions and mount points to my satisfaction. So I rolled up my sleeves and hacked away at this script in between taking care of the kids and wife this weekend.

The issues I have with current disk drive powershell scripts on the internet are two-fold. Firstly, none of the functions I found were properly written for utilizing alternate credentials. Secondly, using the Win32\_DiskDrive provides excellent details on physical disks and partitions (using associators to Win32\_DiskDriveToDiskPartition and then to Win32\_LogicalDiskToPartition). But you need to use Win32\_Volume to get anything at all about mount points on a disk. And there is literally no solid correlation between the Win32\_Volume and the other classes. So you can use Win32\_Volume to get mount point and disk information but it will not have vendor information or other pertinent properties. You can also get up to a certain point with Win32_DiskDriveToDiskPartition for mount points. Basically you can guess what might be a mount point but there is no way to get the capacity or free space.

To get around these issues I wrote this function to return as much information about disks which can be found without Win32\_Volume. I then tack on educated guesses on possible mount points from Win32\_Volume as well (by looking for volumes returned without a drive letter assigned). The end result is that you will get more results from running this script than you will have drives on the system if there are mount points! I rectified this with custom properties for each type of result; disk, partition, and mountpoint.

For the mountpoint information returned, I use a regex to include a sortable drive letter property among other things. The end result is more than enough information to filter out your results to get the drive data you are seeking.

## Version

Version         :   1.0.0 June 21th 2013
  
&#8211; First release

## Notes

None but all recommendations and improvements are welcome.

## Screenshots

Here is an example of output just run locally against my laptop:

<pre>Model            : SAMSUNG SSD PM800 TH 64G
Disk             : \\.\PHYSICALDRIVE0
PrimaryPartition : True
Drive            : C:
VolumeName       : 
FreeSpace        : 11.77
Description      : Installable File System
SerialNumber     :</pre>

<pre>PercentageFree   : 19.75
DiskSize         : 59.62
Partition        : Disk #0, Partition #0
DiskType         : Partition
Computer         :</pre>

## Downloads

[Download the script from the technet gallery (more frequently updated)][1]

[Download the script from this site (less frequently updated)][2]

 [1]: http://gallery.technet.microsoft.com/Use-Powershell-to-Gather-b5c746d0
 [2]: /wp-content/uploads/2013/06/Get-RemoteDiskInformation.ps1