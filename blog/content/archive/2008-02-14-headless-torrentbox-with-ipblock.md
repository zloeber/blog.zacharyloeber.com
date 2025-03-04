---
title: Headless torrentbox with ipblock
author: Zachary Loeber
type: post
date: 2008-02-14T16:10:54+00:00
url: /blog/2008/02/14/headless-torrentbox-with-ipblock/
categories:
  - Linux
  - Networking
  - Ubuntu

---
As you may or may not know there are a lot of people who seem to be interested in the torrent activities of others. Some just like to track, others are government agencies, and of course the RIAA. I personally don&#8217;t like this intrusion into my habits so I do my best to block their attempts. In this small tutorial I&#8217;m going to cover how to install torrentflux with ipblock and fail2ban in a headless mode so you can download and seed torrents a bit more securely.
  
<!--more-->


  
This is going to assume you have an ubuntu 7.10 LAMP server already setup. Here we go!

First get the prerequisites:

`apt-get install libnetfilter-queue1 libnfnetlink0`

Get the iplist package [here][1] this package includes the ipblock software as well.

`wget <link to ipblock software>`

``Now since we are not using a front end we have to finagle the deb file so there aren&#8217;t any dependency issues with uninstalled graphical interfaces and tools.

`dpkg-deb -x iplist_0.18-0gutsy1_i386.deb ./iplist_deb<br />
dpkg-deb -e iplist_0.18-0gutsy1_i386.deb iplist_deb/DEBIAN<br />
cd iplist_deb/DEBIAN/<br />
nano ./control<br />
` 
  
In the line that starts with &#8220;Depends:&#8221; get rid of the last three dependencies. So kill of the following at the end of the line:

`", sun-java5-jre | sun-java6-jre, gksu"`

Save and exit then rebuild the package

`cd ../../<br />
dpkg -b ./iplist_deb iplist_0.18-0gutsy1_i386.deb<br />
sudo dpkg -i iplist_0.18-0-headless_gusty_i386.deb`

`sudo cp /usr/share/doc/iplist/examples/ipblock.conf /etc/<br />
sudo cp /usr/share/doc/iplist/examples/allow.p2p /etc/`

`sudo nano /etc/ipblock.conf`

Set to start at boot (not sure if this actually works w/o the gui but it doesn&#8217;t hurt)
  
`AUTOSTART="Yes"`

Setup your blocklists based on your preferences from the files listed in /usr/share/doc/iplist/README.lists
  
`BLOCK_LIST="level1.gz Microsoft.gz ads-trackers-and-bad-pr0n.gz spy bogon.gz templist.gz"`

I also like to keep my logfiles in one tidy spot and thusly change the LOG_FILE variable as follows, but this is entirely personal preference.
  
`LOG_FILE="/var/log/ipblock.log"`

`sudo ipblock -u<br />
sudo /etc/init.d/ipblock start<br />
sudo ipblock -l`

Note: The updates run daily and the script can be found as /etc/cron.daily/ipblock Move or update this as you see fit, I like it updating daily though.

Finally make sure it starts at boot by checking with sysv-rc-conf or similar rc level tools.

Cheers!

 [1]: http://superb-east.dl.sourceforge.net/sourceforge/iplist/iplist_0.18-0gutsy1_i386.deb "iplist"