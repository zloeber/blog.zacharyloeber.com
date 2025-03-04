---
title: 'Ubuntu Server 8.04 Post Install Tip #3: Blacklist Modules'
author: Zachary Loeber
type: post
date: 2008-07-06T23:35:48+00:00
url: /blog/2008/07/06/ubuntu-server-804-post-install-tip-3-blacklist-modules/
categories:
  - Linux
  - Ubuntu

---
Here is another one that you may find useful to do after a default install of probably any Linux server, Disabling extra stuff from loading at startup. Ubuntu loads a ton of them and many I do not use at all. Since when do you need joystick or sound support on a server anyway? Anyways, here are some I disable and how I disable them.
  
<!--more-->


  
IPV6 might cause you some trouble. If your router does not support IPV6 (or still only supports IPV4, which is 99% of all routers), you will have no use for IPV6. Unless you are using IPv6 it also adds an entire network stack to your running server. A stack that needs to be secured for every service. So ipv6 will be the first blacklisting it in /etc/modprobe.d/blacklist.

We may as well disable all those annoying sound modules from loading. So lets find out what sound modules should be blacklisted. I have on-board sound and I believe that the modules gets auto detected via a series of detection scripts in /etc/modprobe.d/alsa-base so I have to be a bit more specific in the blacklist. Find out how the sound modules are getting loaded. As you can see from the command below the via82xx on board sound module is getting loaded. If in doubt just blacklist &#8217;em all.

`12:59:13 shadowbox /etc/modprobe.d: lsmod | grep snd<br />
snd_via82xx            29464  0<br />
snd_ac97_codec        100260  1 snd_via82xx<br />
ac97_bus                3200  1 snd_ac97_codec<br />
snd_pcm                80388  2 snd_via82xx,snd_ac97_codec<br />
snd_timer              24324  1 snd_pcm<br />
snd_page_alloc         11528  2 snd_via82xx,snd_pcm<br />
snd_mpu401_uart         9600  1 snd_via82xx<br />
snd_rawmidi            25728  1 snd_mpu401_uart<br />
snd_seq_device          9228  1 snd_rawmidi<br />
snd                    54532  7 snd_via82xx,snd_ac97_codec,snd_pcm,snd_timer,<br />
snd_mpu401_uart,snd_rawmidi,snd_seq_device<br />
gameport               16776  2 snd_via82xx,analog<br />
soundcore               8800  1 snd`

Ok with this knowledge we will begin blacklisting. I&#8217;ve added a few others related to sound and joystick devices just to be all inclusive

`sudo nano /etc/modprobe.d/blacklist`

add the following at the bottom

    # Stop ipv6 from loading
    blacklist ipv6
    
    # Stop the annoying pc speaker from beeping when local.
    blacklist pcspkr
    
    # Stop all those damn sound modules from loading.
    blacklist snd
    blacklist soundcore
    blacklist snd_via82xx
    blacklist gameport
    blacklist snd_ac97_codec

Then reboot like so:
  
`sudo reboot now`

I&#8217;m sure I could shave off a few other modules like the printer port (parport_pc) and the floppy (floppy) but this generally suites my needs and is a good start.