---
title: Create Your Own Network Assessment Appliance
author: Zachary Loeber
type: post
date: 2012-04-09T00:49:19+00:00
excerpt: In this write-up I setup several network assessment tools which can be used in the discovery process of a new environment. This can be useful for a newly hired sysadmin or a consultant in rapidly gathering information to assess the health and/or state of a network.
url: /blog/2012/04/08/create-your-own-network-assessment-appliance/
categories:
  - Active Directory
  - Active Directory
  - Linux
  - Microsoft
  - Networking
  - Security
  - System Administration
  - Virtualization
  - VMware
tags:
  - Active Directory
  - Linux
  - network administration
  - Networking
  - Sysadmin
  - System Administration
  - virtualization
  - vmware

---
In this write-up I setup several network assessment tools which can be used in the discovery process of a new environment. This can be useful for a newly hired sysadmin or a consultant in rapidly gathering information to assess the health and/or state of a network.

## Introduction

I often find myself assessing a foreign network infrastructure for performance or other issues. Depending on the size of the environment, digesting everything can be daunting without the help of some third party tools. I&#8217;ve been using a custom Linux VM on my workstation that has all kinds of tools specifically for gathering information about a network&#8217;s performance, layout, and statistics. I&#8217;ve decided to retool the VM I currently use and take better notes on what I install so others may do the same if they so desire.

## List of tools installed

### [Nedi][1]

Nedi is probably the coolest network information gathering tool out there. You can create maps, population reports, and get more information than you ever wanted to know about an environment. The catch is that you really want to enable cdp/lldp (FDP?) on all infrastructure devices and make sure that they all have an SNMP read-only string configured. You also gain benefits by setting the SNMP location string in a particular format.

This format (directly from the nedi site) is as follows:

Region;City;Building;Floor;\[Room;\]\[Place within room;\][Whatever additional info you want]

Example SNMP location string for a device:

Illinois;Chicago;Main Station;5;DC;Rack 17;7-8

Even if you don&#8217;t have the time to set all these locations on all devices the information gathered from Nedi (that is more of a task for the system administrator as it requires knowledge of device placement and such ahead of time), the information gathered with the tool still very valuable for performing analysis of an environment. Nedi is really meant to squat on the network and gather information over a period of time. In this article I do not set it up with any cron jobs as I normally run this appliance from my laptop for short term engagements for general environment analysis only. I use a few other applications to gather performance metrics for short periods of time that I’m on site.

### [Observium][2]

This is one of those hidden gems which I&#8217;m surprised more people are not using. Observium terms itself as:

> &#8230;an autodiscovering PHP/MySQL/SNMP based network monitoring which includes support for a wide range of network hardware and operating systems including Cisco, Linux, FreeBSD, Juniper, Brocade, Foundry, HP and many more.
> 
> Observium has grown out of a lack of easy to configure network monitoring platforms. It is intended to provide a more navigable interface to the health and performance of your network. Its design goals include collecting as much historical data about devices as possible, being completely autodiscovered with little or no manual intervention, and having a very intuitive interface.

I use Observium as an alternate way of mapping out a network by interface. Here is a quick example of what such output may look like with a couple of HP switches at the core connected to each other and to a few other cisco switches:

<div id="attachment_520" style="width: 160px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/04/Observium.jpg"><img class="size-thumbnail wp-image-520" title="Observium" src="/wp-content/uploads/2012/04/Observium.jpg?resize=150%2C150" alt="Observium Port Mapping" width="150" height="150" srcset="/wp-content/uploads/2012/04/Observium.jpg?resize=150%2C150 150w, /wp-content/uploads/2012/04/Observium.jpg?zoom=2&resize=150%2C150 300w, /wp-content/uploads/2012/04/Observium.jpg?zoom=3&resize=150%2C150 450w" sizes="(max-width: 150px) 100vw, 150px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Figure 1: Example Observium Map
  </p>
</div>

I also use it for a short term performance monitor of an environment’s equipment. As an example, I once used it to determine that a random network outage that lasted less than a minute was isolated to an old catalyst switch with an IOS bug that forced a reboot from memory over-consumption.

The BIG caveat to using this tool is that any device added needs to be able to resolve in DNS. It is the author&#8217;s preference (and I kinda do not blame the man, not enough people fully resolve their infrastructure equipment).

### [Xerela][3]

Ok, this one was going to be NetworkAuthority (which I&#8217;ve setup in the past). But when I went to go install it again I was unsurprised to find out that it had died. Fortunately an open sourced project forked from it called Xerela. Even more fortunate is that the project is windows only with a nice installer. So this isn&#8217;t going to be officially covered in this install guide but I felt the need to give the project props in hopes that it stays alive 🙂 If you do install this on your laptop you will need the Java SDK installed so may as well [download that][4] ahead of time. Oh, and [install perl][5] as well.

In the future I may shove Rancid into this position but the goal of Rancid is more long term rather than assessment oriented. It is great at collecting configurations but the primary use is to collect and diff the configs to be able to know what is changing in your environment. If you go onsite for a day or two the effort to setup Rancid just to get a copy of device configs is not really worth it.

### Smokeping

I use this tool to gather information concerning internet latency. Sometimes network issues are not necessarily internal but rather provider based. This can be used to provide evidence of latency issues which a provider may be having. And the graphs it produces look pretty on a deliverable report as well J

### Nipper-NG

Nipper is used for firewall configuration auditing. Nipper became a commercial product some time ago but, with a little work, you can still use the fork of the OSS version though. Generating reports from this appliance is not as [easy as using NipperME][6] but it is certainly not impossible. I don’t cover NipperME as this appliance is really meant to be headless in use. I may go into the many windows tools I use for network analysis in a future write up though.

## Pre-requisites

When installing ubuntu at the install screen press F4 for modes and select the minimal virtual machine install mode. Select the OpenSSH Server and the LAMP Server options. Create your user and a root mysql password and keep a note of them.

Get some base software and prep your sandbox some:

<pre>sudo apt-get update</pre>

<pre>sudo apt-get upgrade</pre>

<pre>sudo apt-get install apache2 libapache2-mod-php5 mysql-server libnet-snmp-perl php5-mysql libnet-telnet-cisco-perl php5-snmp php5-gd libalgorithm-diff-perl rrdtool librrds-perl nano htop ipcalc unzip  ipmitool rrdtool fping graphviz libnet-ssh-perl libnet-ssh2-perl nmap php5-cli php5-snmp imagemagick whois mtr-tiny php-pear snmp nmap ipcalc subversion smokeping sendmail  liblog-log4perl-perl liblog-dispatch-perl libsnmp-perl php5-ldap</pre>

<pre>sudo pear install Net_IPv6
sudo pear install Net_IPv4</pre>

<pre>cd</pre>

<pre>mkdir ./Applications</pre>

## 

## Nedi

Now time for nedi.

<pre>cd /tmp</pre>

<pre>wget <a href="http://www.nedi.ch/pub/nedi-1.0.7.tgz">http://www.nedi.ch/pub/nedi-1.0.7.tgz</a></pre>

<pre>wget -O NeDi2GraphMLv0.13.zip  '<a href="http://downloads.sourceforge.net/project/nedi2graphml/NeDi2GraphMLv0.13.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnedi2graphml%2F&ts=1332013513&use_mirror=iweb">http://downloads.sourceforge.net/project/nedi2graphml/NeDi2GraphMLv0.13.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnedi2graphml%2F&ts=1332013513&use_mirror=iweb</a>'
unzip ./NeDi2GraphMLv0.13.zip -d ~/Applications/
sudo su -
mkdir /var/www/nedi
tar -C /var/www/nedi -xzvf ./nedi-1.0.7.tgz
mkdir /var/www/nedi/log
chmod 775 -R /var/www/nedi/
perl -pi -e 's/\/var\/nedi/\/var\/www\/nedi/g' /var/www/nedi/nedi.conf
perl -pi -e 's/snmpwrite/#snmpwrite/g' /var/www/nedi/nedi.conf
chown www-data:www-data -R /var/www/nedi
/var/www/nedi/nedi.pl -i
&lt;enter in "root" for the user and your root mysql password for the password&gt;
echo -e '&lt;VirtualHost *:80&gt;' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '  DocumentRoot /var/www/nedi/html/' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '  ServerName  localhost' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '  &lt;Directory "/nedi"&gt;' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '    AllowOverride All' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '    Options FollowSymLinks MultiViews' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '  &lt;/Directory&gt;' &gt;&gt;/etc/apache2/sites-available/nedi
echo -e '&lt;/VirtualHost&gt;' &gt;&gt;/etc/apache2/sites-available/nedi
a2ensite nedi
service apache2 restart</pre>

There, now you are able to access nedi at http://<server ip>/nedi/html with the admin/admin credentials. If you find you are reusing this tool for many sites you can easily customize it by logging in, going to System -> Files, and using the first dropdown in the upper left to select /var/www/nedi/seedlist and/or /var/www/nedi/nedi.conf to modify snmp/logon string and initial seedlists for an environment. Then clear things out from the last engagement you may have done by going to the System -> Nedi area, selecting the &#8220;Init&#8221; radio button on the right and entering in root for your user and your mysql password for the password. Execute that puppy and all data cleared. Finally select verbose, protocol, node dev, FQDN, Route, and OUI checkboxes and the &#8220;discover&#8221; radio box. Click execute again and depending on the environment size wait around for a bit while watching all that beautiful information roll down on the screen.

As a bonus I also include NeDi2GraphML. This can be used to create some pretty [wicked looking diagrams which you can edit with yED][7]. To create a diagram you can run the following after having performed your initial collection.

<pre>cd ~/Applications/NeDi2GraphMLv0.13/
perl NeDi2GraphML.pl -o NiceSchematic.graphml --icn icons.csv</pre>

Then transfer NiceSchemmatic.graphml to your workstation for editing as you see fit.

## Observium

Setup your observium home and get it installed (I ran into issues not running observium from opt so that is why it is there)

<pre>sudo su -</pre>

<pre>mkdir -p /opt/observium && cd /opt</pre>

<pre>svn co <a href="http://www.observium.org/svn/observer/trunk">http://www.observium.org/svn/observer/trunk</a> observium</pre>

<pre>cd observium</pre>

<pre>cp ./config.php.default ./config.php</pre>

<pre>mysql -u root -p

&lt;mysql root password&gt;</pre>

<pre>CREATE DATABASE observium;
GRANT ALL PRIVILEGES ON observium.* TO 'observium'@'localhost' IDENTIFIED BY 'dbpa55';</pre>

<pre>QUIT</pre>

<pre>perl -pi -e 's/USERNAME/observium/g' /opt/observium/config.php</pre>

<pre>perl -pi -e 's/PASSWORD/dbpa55/g' /opt/observium/config.php</pre>

<pre>ln -s /usr/bin/pear /usr/share/pear</pre>

<pre>sudo php includes/sql-schema/update.php</pre>

<pre>sudo mkdir graphs rrd
sudo chown -R www-data.www-data observium</pre>

<pre>./adduser.php admin admin 10</pre>

<pre>echo -e '33  */6   * * *   root    cd /opt/observium/ && ./discovery.php -h all &gt;&gt; /dev/null 2&gt;&1' &gt;&gt;/etc/cron.d/observium</pre>

<pre>echo -e '*/5 *   * * *   root    cd /opt/observium/ && ./discovery.php -h new &gt;&gt; /dev/null 2&gt;&1' &gt;&gt;/etc/cron.d/observium</pre>

<pre>echo -e '*/5 *   * * *   root    cd /opt/observium/ && ./poller.php -h all &gt;&gt; /dev/null 2&gt;&1'  &gt;&gt;/etc/cron.d/observium</pre>

<pre>echo -e '&lt;VirtualHost *:81&gt;' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '  DocumentRoot /opt/observium/html/' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '  &lt;Directory "/opt/observium/html/"&gt;' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '    AllowOverride All' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '    Options FollowSymLinks MultiViews' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '  &lt;/Directory&gt;' &gt;&gt;/etc/apache2/sites-available/observium
echo -e '&lt;/VirtualHost&gt;' &gt;&gt;/etc/apache2/sites-available/observium</pre>

<pre>a2ensite observium</pre>

<pre>/etc/init.d/cron reload</pre>

<pre>a2enmod rewrite
echo -e 'Listen 81' &gt;&gt; /etc/apache2/ports.conf
service apache2 restart
exit</pre>

If you will be using observium in an assessment you will gain the most value by adding devices to it early on. It really excels in gathering performance information in a manner which is easy to maneuver through. You can now access observium at http://<ip address>:81/

## SmokePing

This is probably the easiest one to setup. Just add a few external targets to monitor and start the service.

<pre>echo -e '+ Internet' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'menu = Internet Sites' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'title = Internet Sites' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e '++ Google' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'menu = Google.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'title = Google.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'host = google.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e '++ Yahoo' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'menu = Yahoo.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'title = Yahoo.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'host = yahoo.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e '++ Reddit' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'menu = Reddit.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'title = Reddit.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'host = reddit.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e '++ Amazon' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'menu = amazon.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'title = amazon.com' &gt;&gt; /etc/smokeping/config.d/Targets
echo -e 'host = amazon.com' &gt;&gt; /etc/smokeping/config.d/Targets
service smokeping start</pre>

To access smokeping go to http://<ip address>/cgi-bin/smokeping.cgi

## Nipper-NG

This one is pretty easy:

<pre>cd /tmp
svn checkout http://nipper-ng.googlecode.com/svn/trunk/ nipper-ng
cd nipper-ng
make
sudo make install</pre>

Then use nipper at the command line to see options for scanning your firewall configuration and generating client consumable deliverables.

## Extras

I’ve added a few extra applications in this appliance setup which can be used (or not) in an assessment. I ran across a few of them while doing this write up and have not actually used them in a real assessment. But they show potential and are pretty easy to setup so I decided to include them in the appliance. I give minimal instructions on their usage (as I’ve minimally used them). I’ll leave it as an exercise to the reader to determine their worthiness.

### SwitchMap

I’ve literally never used this before but the project looks promising so I did a very basic setup for future use. Much of what I read from the readme points to a process where you setup a config file, run some scripts in order, and finally run a script which produces an html formatted report. I’m looking forward to using this when the opportunity presents itself.

<pre>cd /tmp</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/switchmap/switchmap-12.4.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fswitchmap%2F&ts=1333827546&use_mirror=voxel">http://downloads.sourceforge.net/project/switchmap/switchmap-12.4.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fswitchmap%2F&ts=1333827546&use_mirror=voxel</a>' -O switchmap.tar.gz
tar -C ~/Applications -xzvf ./switchmap.tar.gz</pre>

### Open-AudIT

This little bad boy is not really new to me but my experience with it is minimal. I decided to add it to the appliance to get more experience with its usage and see if I can gain further assessment information from it for future engagements.

The setup for the appliance is fairly basic. You just need to download it, put it into a php/apache capable directory, and change a few perms.

<pre>sudo su -
cd /tmp
wget ‘http://downloads.sourceforge.net/project/open-audit/open-audit-release-candidate/Open%20Audit%20Release%20Candidate/OpenAuditReleaseCandidate.09.03.17.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fopen-audit%2Ffiles%2F&ts=1333927081&use_mirror=superb-dca2’ -O ./openaudit.zip
unzip ./openaudit.zip
mv ./OpenAuditReleaseCandidate ./var/www/openaudit
chmod 777 /var/www/openaudit/scripts/pc_list_file.txt
chmod 777 /var/www/openaudit/audit.config
chmod 777 /var/www/openaudit/include_config*.*
chown -R www-data.www-data /var/www/openaudit/
exit</pre>

After this is done go to http://<ip address>/openaudit and go through the initial configuration steps. Use root/<mysql root password> when asked for database information.

To actually get a domain audit is a bit more of a pain. The general process is to make your appliance available to the network, download a config and a vbs file from it to a DC, modify the config, then run the vbs to start collecting server information to send back up to appliance.

From the Admin->Config page add an ldap connection. After it has been added add a path as well, it may not be immediately discernible where this is done. Simply hover over the ldap connection and select “Add New Path” from the pop-up menu (as shown below). Make the path the root of the domain you are assessing (ie. DC=zacharyloeber,DC=net)

<div id="attachment_522" style="width: 160px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/04/Open-AudIT1.jpg"><img class="size-thumbnail wp-image-522" title="Open-AudIT" src="/wp-content/uploads/2012/04/Open-AudIT1.jpg?resize=150%2C150" alt="Open-AudIT LDAP Config" width="150" height="150" srcset="/wp-content/uploads/2012/04/Open-AudIT1.jpg?resize=150%2C150 150w, /wp-content/uploads/2012/04/Open-AudIT1.jpg?zoom=2&resize=150%2C150 300w" sizes="(max-width: 150px) 100vw, 150px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Figure 2: Open-AudIT LDAP Config
  </p>
</div>

Then remote to a DC and access http://<ip address>/openaudit/scripts/ from a web browser, download audit.config and audit.vbs from it to the local machine, and edit audit.config. Below is audit.config pertinent configuration settings (not the entire audit.config, just the areas which are most important)

> **audit_location = &#8220;r&#8221;**
> 
> **audit_host=&#8221;http://192.168.1.148&#8243;**
> 
> **strComputer = &#8220;&#8221;**
> 
> **audit\_local\_domain = &#8220;y&#8221;**
> 
> **local_domain = &#8220;LDAP://dc=zacharyloeber,dc=net&#8221;**
> 
> **nmap_subnet = &#8220;172.17.0.&#8221;            &#8216; The subnet you wish to scan**
> 
> **nmap\_subnet\_formatted = &#8220;172.017.000.&#8221;    &#8216; The subnet padded with 0&#8217;s**

Then, from that same directory, (where both the audit.config and audit.vbs files are located) run:

<pre>cscript.exe audit.vbs</pre>

## Tying It All Together

We are not really tying these apps together as much as making them usable for you from your laptop. If you are using VMware workstation then you need to setup some NAT love to get things working. Typically VMware workstation will use vmnet8 for NAT so you will want to go into the virtual network editor and setup a few NAT Setting rules on it for your new network info collecting baby.

The primary NAT settings which need to be set are as follows:

<table width="521" border="1" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="bottom" nowrap="nowrap" width="83">
      <span style="color: #ffffff;"><strong>Host Port</strong></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="64">
      <span style="color: #ffffff;"><strong>Type</strong></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="244">
      <span style="color: #ffffff;"><strong>Virtual Machine IP Address</strong></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="130">
      <span style="color: #ffffff;"><strong>Description</strong></span>
    </td>
  </tr>
  
  <tr>
    <td style="text-align: justify;" valign="bottom" nowrap="nowrap" width="83">
      <p align="right">
        <span style="color: #00ffff;">22</span>
      </p>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="64">
      <span style="color: #00ffff;">TCP</span>
    </td>
    
    <td style="text-align: justify;" valign="bottom" nowrap="nowrap" width="244">
      <span style="color: #00ffff;"><IP Address></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="130">
      <span style="color: #00ffff;">SSH</span>
    </td>
  </tr>
  
  <tr>
    <td valign="bottom" nowrap="nowrap" width="83">
      <p align="right">
        <span style="color: #00ffff;">8088</span>
      </p>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="64">
      <span style="color: #00ffff;">TCP</span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="244">
      <span style="color: #00ffff;"><IP Address></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="130">
      <span style="color: #00ffff;">Nedi, Open-AudIT, Smokeping</span>
    </td>
  </tr>
  
  <tr>
    <td valign="bottom" nowrap="nowrap" width="83">
      <p align="right">
        <span style="color: #00ffff;">8090</span>
      </p>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="64">
      <span style="color: #00ffff;">TCP</span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="244">
      <span style="color: #00ffff;"><IP Address></span>
    </td>
    
    <td valign="bottom" nowrap="nowrap" width="130">
      <span style="color: #00ffff;">Observium</span>
    </td>
  </tr>
</table>

## Conclusion

Although this little setup guide only covers a small portion of the tools I use on a daily basis it should be enough for most people to get their feet wet. I do not at all cover the ways which I utilize the data collected from an environment to come to an assessment for a client. This is because each environment and engagement is different. If you are looking for security issues your assessment will be far different than if you are looking for causes of a periodic network slowdown (or not, root/cause analysis can lead to some pretty interesting results). Besides, if you understand networking and infrastructure then you will know what you are looking for far better than I could verbalize.

 [1]: http://www.nedi.ch/about/
 [2]: http://www.observium.org/wiki/Main_Page
 [3]: http://code.google.com/p/xerela/
 [4]: http://www.oracle.com/technetwork/java/javase/downloads/index.html
 [5]: http://www.activestate.com/activeperl/downloads
 [6]: http://sourceforge.net/projects/nipperme/
 [7]: http://www.yworks.com/en/products_yed_about.html