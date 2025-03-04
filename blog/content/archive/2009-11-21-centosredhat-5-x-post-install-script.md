---
title: CentOS/Redhat 5.x Post-Install Script
author: Zachary Loeber
type: post
date: 2009-11-21T18:51:06+00:00
url: /blog/2009/11/21/centosredhat-5-x-post-install-script/
categories:
  - Linux
  - Networking
  - RedHat/CentOS
  - System Administration

---
I whipped up a post install script to run on our new linux servers that drastically reduced the amount of manual effort involved with post-deployment configuration. I&#8217;m sure this could some how be integrated into the kick deployment. In any case, this script helps setup your sudo users, snmp services, and some other basic things. Modify to your environment and run directly after deployment on your headless linux servers. Save the script and change to .sh and run with sh ./centos-postinsatll.sh at a command prompt. Cheers!

<a rel="attachment wp-att-103" href="/?attachment_id=103">centos-postinstall</a>