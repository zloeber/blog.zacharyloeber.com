---
title: 'BIG-IP: Load Balancer Upgrade'
author: Zachary Loeber
type: post
date: 2009-12-07T14:46:24+00:00
excerpt: I had the pleasure of doing an F5 BIG-IP load balancer upgrade recently and am happy with the way the F5 people have designed their systems for fail over. . Here is a quick rundown of what I had to do...
url: /blog/2009/12/07/big-ip-load-balancer-upgrade/
categories:
  - BIG-IP
  - Linux
  - Networking
  - System Administration

---
I had the pleasure of doing an F5 BIG-IP load balancer upgrade recently and am happy with the way the F5 people have designed their systems for fail over. Essentially you will use different system partitions to host different versions of their product and you change which one you want to boot to after updating the inactive partition. This, theoretically, means you can always go back to a working configuration if something goes awry. I&#8217;m unhappy with how fragmented their documentation is in getting from point A to point B though. Here is a quick rundown of what I had to do&#8230;

<!--more-->

Remote into your bigip management interface as an administration account then get to root

su &#8211;

Save your license file information just in case

cat bigip.license

Download your iso upgrade image and copy it to /shared/images with something like winscp for windows or just scp for linux. If the images directory doesn&#8217;t exist you must create it first (so they say in the docs)

If you are on an old version like me (9.x.x) you will have to run im ./shared/images/youriso.iso to extract and install the new upgrade utility. This will also show you active vs. an inactive drives:

`[admin@bigip2:Active] config # su -<br />
[admin@bigip2:Active] config # cd /shared/images/<br />
[admin@bigip2:Active] images # im ./BIGIP-10.0.1.283.0.iso<br />
/tmp/rpmdisk.ursNzQ /shared/images<br />
info: system has tm_install-2.5.0-80.0<br />
info: system has perl-RPM2-0.67-10.0.1.283.0<br />
The im utility is no longer used to upgrade software images.<br />
Please use 'image2disk'. For help, use 'image2disk -h'.<br />
You must always install to an image location that is not in use.<br />
Here is your current image-location status:<br />
bigip.license   CF1.1 active no default no title BIG-IP 9.3.0 Build 178.5<br />
HD1.1 active yes default yes title BIG-IP 9.4.5 Build 1049.10<br />
HD1.2 active no default no title BIG-IP 10.0.1 Build 283.0`

So you see that I&#8217;ll be installing (or rather already installed to) HD1.2. You may have to find and clear out old images if you are short on space. There /shared directory is literally shared between partitions so clearing from the live system from that location will clear from both install partitions. If you are ready then install like so:

`[admin@bigip2:Active] images # image2disk --instslot=HD1.2 ./BIGIP-10.0.1.283.0.iso`

After I did this it complained about a license file check and said I had to run with the &#8211;nvlicenseok option. So I did:

`[admin@bigip2:Active] images # image2disk --instslot=HD1.2 --nvlicenseok ./BIGIP-10.0.1.283.0.iso`

When all was done you have to make that partition the default and reboot to it.

`switchboot`

`reboot`