---
title: 'Ubuntu Server 8.04 Post Install Tip #4: Setup SMART'
author: Zachary Loeber
type: post
date: 2008-07-11T15:37:55+00:00
url: /blog/2008/07/11/ubuntu-server-804-post-install-tip-4-setup-smart/
categories:
  - Linux
  - Ubuntu

---
Setup SMART Disk Monitoring

If your disk is going bad no one going to tell you about it until you start hearing it. And if you start hearing issues with your drive it may be too late to backup your data or do anything else you need to do to not be driveless. I&#8217;m uncertain why some of this is not available as an install option for more distros but a good warning before the storm can save your data and your sanity.

<!--more-->

Smart disk monitoring is a built in function on most modern hard drives that will auto detect errors and other issues. The thing is that the drive has this information but you need to setup and install some tools to read it, otherwise smart disk monitoring may be happening regularlly for nothing. What a waste that would be! 🙂

Start by installing it:
  
`sudo apt-get install smartmontools`

First find out which drives you are using:

`mount<br />
<strong>/dev/sda1 on /</strong> type ext3 (rw,errors=remount-ro)<br />
proc on /proc type proc (rw,noexec,nosuid,nodev)<br />
/sys on /sys type sysfs (rw,noexec,nosuid,nodev)<br />
varrun on /var/run type tmpfs (rw,noexec,nosuid,nodev,mode=0755)<br />
varlock on /var/lock type tmpfs (rw,noexec,nosuid,nodev,mode=1777)<br />
udev on /dev type tmpfs (rw,mode=0755)<br />
devshm on /dev/shm type tmpfs (rw)<br />
devpts on /dev/pts type devpts (rw,gid=5,mode=620)<br />
securityfs on /sys/kernel/security type securityfs (rw)`

This displays all mounted media, look for /dev/sda# or /dev/hda1#. Where # is a letter of a partition and the sda/hda portion is the reference to the drive. This can be sdb,sdc,hdb,hdc, et cetera depending on how many drives you have. The sd drives are Sata, the hd drives are Pata. I&#8217;ll be monitoring my sata drive or sda

Now see if the devices are SMART capable by running this for each device we will monitor:

`sudo smartctl -a /dev/sda | grep "SMART support"<br />
SMART support is: Available - device has SMART capability.<br />
SMART support is: Enabled`

Ok, we have the support we need so lets enable the daemon (this must be done in the following config file else the daemon will not start even if enabled at startup.

`sudo nano /etc/default/smartmontools<br />
# uncomment to start smartd on system startup<br />
start_smartd=yes`

Now change the monitoring options by commenting out the auto detection and adding in your own as well as your options. For the type of disk (after the -d) you can find some excellent examples from the smartd.conf manual. A quick list though:

-d type where type is:
  
ata &#8211; Basic or older pata drive
  
scsi &#8211; scsi drive, maybe on a server
  
sat &#8211; sata drive or any one acting like sata so: /sda, /sdb, /sdc, et cetera
  
marvell &#8211; marvell chip-set based drive controllers
  
3ware,N &#8211; 3ware chip-set based RAID controller (N=drive in array to be monitored)
  
hpt,L/M/N = Highpoint RocketRAID controller (L=controller id/M=channel/N=pmport if available)
  
cciss,N = cciss RAID controller (N=drive in array to be monitored)
  
removable = if the drive is not there when starting continue loading smartd instead of exiting

Here are some other options we will use as well

-n standby,q
  
Force disks not to spin up and check status when being checked if the disk is in standby or sleep, the q supresses informational logging which would spin up the disk as well

-H
  
Check health status of disk

-l error -l selftest
  
Check SMART log for errors and selftest errors (check if it has increased since the last check)

-s (O/../../5/11|L/../../5/13|C/../../5/15)
  
Run self tests at regular intervals. This is different than the basic autmatic polling that occurs every 30 minutes. The regex statements mean
  
O = offline intermediate checks (ATA only) on the 5th day of the week at 11
  
L = long test on the 5th day of the week at hour 13 (2pm)
  
C = Conveyance self test (ATA only) on the 5th day of the week at hour 15 (3pm)

-m root -M exec /usr/local/bin/smartd.sh
  
Send an e-mail to root and then execute smartd.sh

So edit your smartd.conf already:

`sudo nano /etc/smartd.conf`

Now change the following:

    # The word DEVICESCAN will cause any remaining lines in this
    # configuration file to be ignored: it tells smartd to scan for all
    # ATA and SCSI devices.  DEVICESCAN may be followed by any of the
    # Directives listed below, which will be applied to all devices that
    # are found.  Most users should comment out DEVICESCAN and explicitly
    # list the devices that they wish to monitor.
    <strong>#DEVICESCAN -m root -M exec /usr/share/smartmontools/smartd-runner</strong>
    <strong>
    #Add this at the end
    # modify -d sat to be the type of drive you have per the examples in this file you are
    # editing, in this example we are escaping each directive to have them all on separate
    # lines for easier editing and reading
    /dev/sda -d sat\
    -H \
    -l error -l selftest \
    -n standby,q \
    -s (O/../../5/11|L/../../5/13|C/../../5/15) \
    -m root -M exec /usr/local/bin/smartd.sh</strong>

If you are going to shutdown on error then create the smartd.sh file

`sudo nano /usr/local/bin/smartd.sh`

Add this and save:
  
`#!/bin/bash<br />
LOGFILE="/var/log/smartd.log"<br />
echo -e "$(date)\n$SMARTD_MESSAGE\n" >> "$LOGFILE"<br />
mail root < $LOGFILE<br />
# Uncomment to shutdown<br />
# sleep 40s<br />
#shutdown -h now`

Make script executable
  
`sudo chmod +x /usr/local/bin/smartd.sh`

Start the service!
  
`sudo /etc/init.d/smartmontools start`

If you start getting errors and warnings take a look and see what may be wrong. You may just have to start getting your backups up to date.

A few quick commands for the road:

enable smart monitoring
  
`sudo smartmon -S on /dev/sda1`

Do a health check and look for PASSED
  
`smartctl -Hc /dev/sda`

take a peek at all logged errors (there should not be many if any at all). If there are a lot then start looking for either a new drive or a reason for the errors.
  
`sudo smartmon -a /dev/sda1`