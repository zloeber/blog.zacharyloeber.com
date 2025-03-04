---
title: 'Ubuntu Server 8.04 Post Install Tip #1: Auto Updating'
author: Zachary Loeber
type: post
date: 2008-07-03T16:42:43+00:00
url: /blog/2008/07/03/ubuntu-server-804-post-install-tip-1-auto-updating/
categories:
  - Linux
  - Networking
  - Ubuntu

---
On a headless server that you have at home or for testing I like to make sure that all security updates and trivial updates are done automatically. A good sys admin will shy away from this practice for a good reason, updates can mess things up. In a production environment or where the server setup is very complex I can understand the need to manually run updates. For me, well I&#8217;m lazy when it comes to my home machines and generally don&#8217;t have too complex of setups. Also, in my experience, I&#8217;ve hardly ever seen an apt security or trivial update cause any harm (desktop linux I have seen issues though). That being said, I like to force security and trivial updates to happen daily.
  
<!--more-->


  
You have a few ways to do this, you can setup a custom script to run the upgrades or you can use apt-cron. I&#8217;ve done both and am now using apt-cron for my needs as it supports syslog logging which is good for logwatch daily updates. The default setup of apt-cron doesn&#8217;t do much so I&#8217;ll cover a more complex setup in a bit. But if you just want to setup your own script here it is:

`sudo nano /usr/local/sbin/auto-update.sh`
  
Paste all of this:
  
``#!/bin/bash<br />
#<br />
#(modified from: http://ubuntuforums.org/showthread.php?t=100803)<br />
# simple script which does automatic security updates!<br />
# Daniel<br />
#<br />
function warning () {<br />
echo | mail -s "`uname -n`:$0: error [$1]." user@localhost<br />
}<br />
apt-get update > /dev/null 2>&1 || warning update<br />
apt-get upgrade -y -t `lsb_release -cs`-security >> /var/log/apt/security.log 2>&1 || warning upgrade.security<br />
apt-get upgrade -y --trivial-only >> /var/log/apt/trivial.log 2>&1 || warning updade.trivial<br />
apt-get autoclean -y > /dev/null 2>&1<br />
exit<br />
`` 
  
`sudo chmod +x /usr/local/sbin/auto-update.sh`

Test your script:
  
`sudo /usr/local/sbin/auto-update.sh<br />
less /var/log/apt/security.log<br />
` 
  
Now make it run daily
  
`sudo ln -s /usr/local/sbin/auto-update.sh /etc/cron.daily/auto-update<br />
` 
  
**The cron-apt way**

Install cron-apt, remove the default cron-apt schedule and set it to run daily instead. Also remove the default download-only action file as we don&#8217;t need it, we are going to install stuff instead.

`sudo apt-get install cron-apt<br />
ln -s /usr/sbin/cron-apt /etc/cron.daily/cron-apt<br />
sudo mv /etc/cron.d/cron-apt ~/oldffiles/cron-apt<br />
sudo mv  /etc/cron-apt/action.d ~/oldfiles/`

create your install action file. Note that I have hardy-security in here as I was not able to get lsb_release -cs to work in the config file properly, you may have a different distro and will have to change accordingly. In /etc/apt/sources.list you can see the different types that you can use by looking at the following part of the source line.

deb http://security.ubuntu.com/ubuntu **hardy-security** main restricted

`sudo nano /etc/cron-apt/action.d/2-install`
  
Insert the following:
  
`upgrade -y -t hardy-security<br />
upgrade -y --trivial-only<br />
autoclean -y<br />
` 
  
Change the default configuration to do no mailing or debugging. Also error out on errors and always dump all actions to syslog.

`nano /etc/cron-apt/config<br />
` 
  
You will have to uncomment and change the lines noted.

`ERROR="/var/log/cron-apt/error"<br />
DEBUG=""<br />
MAILON=""<br />
SYSLOGON="always"`

Test by running cron-apt
  
`sudo cron-apt`

Then take a look in syslog
  
`less /var/log/syslog`