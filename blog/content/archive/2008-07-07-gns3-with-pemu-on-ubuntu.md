---
title: GNS3 on Ubuntu 8.04 – Pemu Guide
author: Zachary Loeber
type: post
date: 2008-07-07T14:41:08+00:00
url: /blog/2008/07/07/gns3-with-pemu-on-ubuntu/
categories:
  - Uncategorized

---
Ok, so far we have gone through the hoops to get GNS3 with dynamips/dynagen working nicely in an (almost) fully contained directory in /opt. We then went through choosing an IOS image that is right for you, if you actually have multiple legal images to choose from of course. Now lets setup a pix firewall. The PIX is out of life as far as Cisco is concerned and had been superseded by the ASA line of security devices. But, there are still a lot of the PIX around and the concepts haven&#8217;t changed too much between them. So let us go through the motions already!
  
<!--more-->


  
Too get Pemu going on Ubuntu you first need to download it. It is based of of Qemu and the binary is actually quite small. Digging up the right one to use can be a pain but if you are a rockin&#8217; network geek and go to the 7200emu.hacki.at forums, you will be able to find it there.

Get pemu for at http://7200emu.hacki.at/viewtopic.php?t=5383 (note that you have to register to download the fille). Grab  pemu\_2008-03-03\_bin.tar.bz2 and save it to some temporary location.

Extract the pemu files and copy them to the pemu directory in GNS3. Then make a Pix directory for your &#8220;legal&#8221; pix images. Copy your image files to this location.

`tar xjvf pemu_2008-03-03_bin.tar.bz2<br />
cd pemu_2008-03-03_bin<br />
sudo cp ./* /opt/GNS3/pemu<br />
sudo mkdir /opt/GNS3/Pix`

Then copy over your pix images to /opt/GNS3/Pix/

Now lets make sure GNS3 is setup properly. The pemuwrapper.py comes with GNS3 and you need to set the path accordingly. You will want to change your GNS3 settings to point to the image by default and enter in the serial number and activation codes as well. My setup looks like this:

[<img class="aligncenter size-medium wp-image-33" title="preferences-pemu" src="/wp-content/uploads/2008/07/preferences-pemu.png?resize=300%2C271" alt="GNS3 Pemu Preferences" width="300" height="271" data-recalc-dims="1" />][1]

Notice that the activation key is 4 hex values and has to be separated by commas. After it was setup there were still issues with the activation key when I started up a pix firewall. I had to do the following in a console of the emulated pix router to get the unrestricted activation key working.

`enable<br />
format flash:<br />
activation-key 0x-------- 0x-------- 0x-------- 0x--------<br />
copy run start<br />
reload`

After doing this I had issues getting the console to come back up so I closed GNS3 and killed any open gnome-terminal process (there was one in the process list that looked like &#8220;/bin/sh gnome-terminal&#8221;) and then restarted GNS3. After that, everything worked fine.

&#8212; UPDATE &#8212;

Thomas mentioned issues in maintaining settings in labs. I didn&#8217;t have the same issue from one lab to the next initially but after a reboot I did. Here is one way to save the files for loading at a later time. What you want to do is copy the FLASH file from /opt/GNS3/tmp/<your pix name in GNS>/ to another location after you have written it and saved it within the emulator. If you want to setup the serial and activation key to always work, even with a brand new lab do the following:

`cd /opt/GNS3/tmp/<name of pix which you have already activated in previous instructions>/<br />
sudo cp ./FLASH ../../Pix/FLASH.bin<br />
sudo chmod +r ../../Pix/FLASH.bin`

Then enter in the default flash image in in the Pemu preferences of GNS3 as /opt/GNS3/Pix/FLASH.bin and that base FLASH file will be copied over (and renamed to FLASH) for every new Pix instance you create.

As for backing up the running configuration for a future lab you may be able to copy out the Flash file to another location and put it back the next time you startup your machine. I&#8217;ve not tinkered with that yet.
  
&#8212; END OF UPDATE &#8212;

In my next testing I&#8217;ll be messing around with connecting your devices to physical and virtual interfaces. This will let us do connectivity testing (in the case of the virtual interface) and connect to a live network for other fun experiments.

 [1]: /wp-content/uploads/2008/07/preferences-pemu.png