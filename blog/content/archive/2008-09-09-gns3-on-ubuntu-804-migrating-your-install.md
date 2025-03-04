---
title: GNS3 on Ubuntu 8.04 – Migrating Your Install
author: Zachary Loeber
type: post
date: 2008-09-09T20:39:00+00:00
url: /blog/2008/09/09/gns3-on-ubuntu-804-migrating-your-install/
categories:
  - Cisco
  - Linux
  - Networking
  - Ubuntu

---
Don&#8217;t have much time due to work obligations but I wanted to quickly drop this one out there for any who have followed my install guides. I was always ragging on and on about making the install somewhat portable by putting it into the /opt/ directory and now I&#8217;ll give a good example why.

<!--more-->

Not too long ago I got a new laptop and gave my wife my Ubunbut loaded laptop. On the new laptop I was able to easily migrate over the GNS3 install, labs, and IOS images I was using with very little effort. You simply do the following and you are pretty much done!

`sudo apt-get install dynagen python-qt4`

Then move over your entire /opt/GNS3/ directory from the old machine to the new (you choose how) and reset your permissions on some of the directories like so:

`sudo chmod o+rw -R ./Project<br />
sudo chmod o+rw -R ./tmp`

Finally make sure to move over your GNS3 settings file. In GNS3 preferences it shows you were it is at (usually in the home directory as gns3.ini).

And that is it! Note that you may have to redo some of the idle-pc values for your IOS images.