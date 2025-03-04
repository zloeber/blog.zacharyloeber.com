---
title: Converting a Physical machine to a vmware file
author: Zachary Loeber
type: post
date: 2008-03-12T21:19:44+00:00
url: /blog/2008/03/12/converting-a-physical-machine-to-a-vmware-file/
categories:
  - Virtualization

---
Just an FYI, don&#8217;t try to use the vmware converter program to convert a windows 2000 workstation to a virtual machine. It just doesn&#8217;t work. It takes hours and when it is done it tries to setup the disk as a scsi device but doesn&#8217; t install the drivers. Even if you install the drivers ahead of time you may get a BSOD on boot about an inaccessible boot device. Instead use VisionCore&#8217;s vConverter. It worked great the first time for me (and then a second!).