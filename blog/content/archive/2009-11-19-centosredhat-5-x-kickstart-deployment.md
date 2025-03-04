---
title: CentOS/Redhat 5.x Kickstart Deployment
author: Zachary Loeber
type: post
date: 2009-11-19T21:39:18+00:00
excerpt: 'Not too long ago I was tasked with deploying a decent number of CentOS 5.3 and Redhat servers to BL490 blades and VMs in our datacenter (part of a massive environment deployment with HP C7000 enclosures, virtual connect, and a lot of patience). I hate manual configuration so I figured now is as good of time as any to get on the kickstart bandwagon. Here is how I did it:'
url: /blog/2009/11/19/centosredhat-5-x-kickstart-deployment/
categories:
  - Linux
  - Networking
  - System Administration
  - Virtualization

---
Not too long ago I was tasked with deploying a decent number of CentOS 5.3 and Redhat servers to BL490 blades and VMs in our datacenter (part of a massive environment deployment with HP C7000 enclosures, virtual connect, and a lot of patience). I hate manual configuration so I figured now is as good of time as any to get on the kickstart bandwagon. Here is how I did it:   
<!--more-->

   
First you want to make your source install disc and kickstart config files available on the network (more on a good kickstart config file a bit later. There are a number of ways to do this and I actually used both windows and linux for different locations on our network. Essentially you need to make a directory browsable read-only web site on a server that your kickstart configuration can reach from the source host.

The windows configuration is easy so I&#8217;ll leave that exercise to the reader to figure out&#8230;. Ok, the linux part is easy too but requires less bandwidth to explain as I don&#8217;t need screenshots 🙂

In linux-land you create another apache site with a configuration like the following. Note that I used /opt/kickstart/ as my configuration file location and my cdrom as the source disc location:

<pre>$sudo nano /etc/apache2/sites-available/kickstart</pre>

<pre>Alias /kickstart "/opt/kickstart/"</pre>

<pre>Alias /cdrom "/media/cdrom/"</pre>

<pre>&lt;Directory "/opt/kickstart/"&gt;</pre>

<pre>Options Indexes MultiViews FollowSymLinks</pre>

<pre>AllowOverride None</pre>

<pre>Order allow,deny</pre>

<pre>allow from all</pre>

<pre>&lt;/Directory&gt;</pre>

<pre>&lt;Directory "/media/cdrom/"&gt;</pre>

<pre>Options Indexes MultiViews FollowSymLinks</pre>

<pre>AllowOverride None</pre>

<pre>Order allow,deny</pre>

<pre>allow from all</pre>

<pre>&lt;/Directory&gt;</pre>

<pre>$a2ensite kickstart</pre>

<pre>$/etc/init.d/apache2 restart</pre>

If all is well then you have two directories on your server that can be reached over the local network and the files can be browsed.

Next create something like the kickstart file attached to this post for /opt/kickstart/ks-network.txt

Note that the name of the file is arbitrary, it is what will be called when you boot to the inital setup screen on your server and instead of pressing enter to continue with the Linux install you enter in linux ks=http://<server ip>/kickstart/ks-network.txt

I actually have several kickstart files for different situations. The server you will be installing to must be on a subnet with a dhcp address available or you can comment out the url in the file and uncomment the cdrom line to do the install from the local cdrom if you like.

The included kickstart file is a very slimmed down and unforgiving install that will wipe /dev/sda and do a fresh install. There is very little running on the system after this completes.

[ks-network][1]

 [1]: /wp-content/uploads/2009/11/ks-network1.txt