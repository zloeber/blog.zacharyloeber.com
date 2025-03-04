---
title: 'Create Your Own Network Assessment Appliance: Additional Tools'
author: Zachary Loeber
type: post
date: 2012-11-29T02:24:46+00:00
excerpt: "I previously did a write up on a personal virtual machine I like to keep at hand for performing network analysis and discovery. I've since added a few tools to the VM and documented how they were installed so I figured I'd share on how it was done. "
url: /blog/2012/11/28/create-your-own-network-assessment-appliance-additional-tools/
categories:
  - Cisco
  - Linux
  - Networking
  - System Administration
  - Ubuntu
  - Virtualization
tags:
  - Linux
  - Monitoring
  - network administration
  - Networking
  - Sysadmin
  - System Administration
  - Ubuntu
  - vmware

---
# Introduction

I [previously did a write up][1] on a personal virtual machine I like to keep at hand for performing network analysis and discovery. I&#8217;ve since added a few tools to the VM and documented how they were installed so I figured I&#8217;d share on how it was done. Even if you don&#8217;t setup everything in this post it may be worthwhile to glance through it for some network engineering tools which are free to setup and use but not highly publicized. Anyone who cares to read this post has likely heard of Solarwinds but I highly doubt you have heard of all the tools in this list (let alone how to set them up). Regardless, I&#8217;ll start with a tool anyone worth their salt has heard of though, Cacti&#8230;

<!--more-->

## Cacti 0.88

**Site:** <http://www.cacti.net>

### **Purpose**

Cacti is a complete rrdtool performance trend analysis tool. I&#8217;ve been using it for years and can attest to its robustness. Many of the programs I&#8217;m covering have plugin capabilities to integrate Cacti so I decided to set it up first. I also added a ton of third party add-ons and templates to try to cover the gambit of what you may need in an environment. To an extent all the extras make Cacti a fairly capable alerting system as well.

Cacti terms itself as;

> &#8230;a complete network graphing solution designed to harness the power of [RRDTool][2]&#8216;s data storage and graphing functionality. Cacti provides a fast poller, advanced graph templating, multiple data acquisition methods, and user management features out of the box. All of this is wrapped in an intuitive, easy to use interface that makes sense for LAN-sized installations up to complex networks with hundreds of devices.

### Setup

I not only installed Cacti, but I loaded it up with addons.

Install snmpd so we have some test data to graph out to confirm everything is working.

<pre>sudo apt-get install snmpd</pre>

<pre>cd ~/Downloads</pre>

<pre>wget <a href="http://www.cacti.net/downloads/cacti-0.8.8a.tar.gz">http://www.cacti.net/downloads/cacti-0.8.8a.tar.gz</a></pre>

<pre>tar xzvf ./cacti-0.8.8a.tar.gz</pre>

<pre>sudo apt-get install libphp-adodb</pre>

<pre>sudo mv ./cacti-0.8.8a /var/www/cacti</pre>

<pre>sudo chown -R www-data.www-data /var/www/cacti</pre>

<pre>mysql -u root -p</pre>

<mysql root password>

<pre>CREATE DATABASE cacti;
GRANT ALL PRIVILEGES ON cacti.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'cactiuser';</pre>

<pre>QUIT</pre>

<pre>sudo su -</pre>

<pre>cd /var/www/cacti</pre>

<pre>mysql cacti -u root -p &lt; cacti.sql</pre>

<pre>useradd cactiuser -d /var/www/cacti/ -s /bin/false</pre>

<pre>chown -R cactiuser.cactiuser rra/ log/</pre>

<pre>mkdir /var/log/cacti</pre>

<pre>touch /var/log/cacti/cacti.log</pre>

<pre>chmod 777 -R ./rra</pre>

<pre>chmod 777 -R ./log</pre>

<pre>chmod 777 -R ./pluggins</pre>

<pre>chown -R www-data.www-data /var/log/cacti</pre>

<pre>(crontab -l; echo -e '*/5 * * * * php /var/www/cacti/poller.php &gt; /var/www/cacti/log/poller.log 2&gt;&1 ') | crontab</pre>

<pre>echo -e 'Alias /cacti /var/www/cacti' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '&lt;Directory /var/www/cacti&gt;' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        Options +FollowSymLinks' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        AllowOverride None' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        order allow,deny' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        allow from all' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        AddType application/x-httpd-php .php' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        &lt;IfModule mod_php5.c&gt;' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_flag magic_quotes_gpc Off' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_flag short_open_tag On' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_flag register_globals Off' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_flag register_argc_argv On' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_flag track_vars On' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                # this setting is necessary for some locales' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_value mbstring.func_overload 0' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '                php_value include_path .' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        &lt;/IfModule&gt;' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '        DirectoryIndex index.php' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>echo -e '&lt;/Directory&gt;' &gt;&gt; /etc/apache2/conf.d/cacti.conf</pre>

<pre>service apache2 restart</pre>

Go to http://<IP-Address>/cacti to complete the rest of the installation.

I had initially installed via apt-get but the repository only has an older version of cacti. After apt-get removing the install, rrdtool was all confused on where the graphs and scripts were supposed to be so I had to rebuild the poller cache. You may not have to do this but if you do then run the following.

<pre>sudo php /var/www/cacti/cli/rebuild_poller_cache.php</pre>

Then manually kick off the poller:

<pre>sudo php /var/www/cacti/poller.php</pre>

### Cacti Extra Templates

I went ahead and setup a handful of host/graph templates from <http://docs.cacti.net/templates>. Here is how it was done:

<pre>mkdir ~/Downloads/templates && cd ~/Downloads/templates</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:host:firewall:cacti087d_chkpt_firewall.tar.gz">http://docs.cacti.net/_media/usertemplate:host:firewall:cacti087d_chkpt_firewall.tar.gz</a> -O checkpoint-firewall.tar.gz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:host:hp:hp-lefthand-cacti-1.0.zip">http://docs.cacti.net/_media/usertemplate:host:hp:hp-lefthand-cacti-1.0.zip</a> -O lefthand.zip</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:host:cacti_host_template_cisco_asa_-_security_appliance.xml.gz">http://docs.cacti.net/_media/usertemplate:host:cacti_host_template_cisco_asa_-_security_appliance.xml.gz</a> -O asa.xml.gz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:host:juniper:cacti087b_juniper_isg-20091020-yrg.zip">http://docs.cacti.net/_media/usertemplate:host:juniper:cacti087b_juniper_isg-20091020-yrg.zip</a> -O juniper-isg.zip</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:host:juniper:cacti087e_juniper_ive-20100609-yrg.zip-O">http://docs.cacti.net/_media/usertemplate:host:juniper:cacti087e_juniper_ive-20100609-yrg.zip-O</a> juniper-ive.zip</pre>

<pre>wget <a href="http://docs.cacti.net/_media/usertemplate:graph:vmware:vmware_esx_cacti_0_1.zip">http://docs.cacti.net/_media/usertemplate:graph:vmware:vmware_esx_cacti_0_1.zip</a> -O esx.zip</pre>

<pre>wget <a href="http://www.eric-a-hall.com/software/cacti-cisco-memory/cacti-cisco-memory.0.3.tar.gz">http://www.eric-a-hall.com/software/cacti-cisco-memory/cacti-cisco-memory.0.3.tar.gz</a> -O cisco-memory.tar.gz</pre>

<pre>gzip -d ./asa.xml.gz</pre>

<pre>sudo mv ./asa.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>sudo tar -C /var/www/cacti/resource/snmp_queries/ -xzvf ./checkpoint-firewall.tar.gz</pre>

<pre>unzip ./lefthand.zip</pre>

<pre>sudo cp ./HP-LeftHand-Cacti-1.0/*.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>unzip ./juniper-isg.zip</pre>

<pre>sudo mv ./cacti_host_template__juniper_isg.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>unzip ./juniper-ive.zip</pre>

<pre>sudo mv ./resource/snmp_queries/*.xml /var/www/cacti/resource/snmp_queries/ ./cacti_host_template__juniper_isg.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>unzip ./esx.zip</pre>

<pre>sudo mv cacti_host_template_vmware_esx_server.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>sudo mv ./resource/script_server/*.xml /var/www/cacti/resource/script_server/</pre>

<pre>sudo mv ./scripts/*.php /var/www/cacti/scripts/</pre>

<pre>tar -xvzf cacti-cisco-memory.0.3.tar.gz</pre>

<pre>sudo mv ./cacti-cisco-memory/templates/cisco_memory_data_query.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>sudo mv ./cacti-cisco-memory/resource/*.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>sudo mv ./cacti_host_template__juniper_ive.xml /var/www/cacti/resource/snmp_queries/</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti087d_host_template_firewall_-_checkpoint.xml  --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti_host_template_hp_lefthand_system.xml  --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti_host_template_hp_lefthand_cluster.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/lefthand-raid.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/lefthand-volumes.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/lefthand-clusters.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/lefthand-temp.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/asa.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti_host_template__juniper_isg.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti_host_template__juniper_ive.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cacti_host_template_vmware_esx_server.xml --with-template-rras</pre>

<pre>php /var/www/cacti/cli/import_template.php --filename=/var/www/cacti/resource/snmp_queries/cisco_memory_data_query.xml --with-template-rras</pre>

### Cacti Extra Plugins

Now do the same for plugins to get cool things like weathermap, threshold notifications, switch/router config backups, and network discovery:

<pre>sudo apt-get install tftpd flow-tools nfdump</pre>

<pre>cd ~/Downloads</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:aggregate-070b2.tgz">http://docs.cacti.net/_media/plugin:aggregate-070b2.tgz</a> -O aggregate.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:routerconfigs-v0.3-1.tgz">http://docs.cacti.net/_media/plugin:routerconfigs-v0.3-1.tgz</a> -O routerconfig.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:realtime-v0.5-2.tgz">http://docs.cacti.net/_media/plugin:realtime-v0.5-2.tgz</a> -O realtime.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:discovery-v1.5-1.tgz">http://docs.cacti.net/_media/plugin:discovery-v1.5-1.tgz</a> -O discovery.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:mactrack-v2.9-1.tgz">http://docs.cacti.net/_media/plugin:mactrack-v2.9-1.tgz</a> -O mactrack.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:flowview-v1.1-1.tgz">http://docs.cacti.net/_media/plugin:flowview-v1.1-1.tgz</a> -O flowview.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:settings-v0.71-1.tgz">http://docs.cacti.net/_media/plugin:settings-v0.71-1.tgz</a> -O settings.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:thold-v0.4.9-3.tgz">http://docs.cacti.net/_media/plugin:thold-v0.4.9-3.tgz</a> -O thold.tgz</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:superlinks-v1.4-2.tgz">http://docs.cacti.net/_media/plugin:superlinks-v1.4-2.tgz</a> -O superlinks.tgz</pre>

<pre>wget <a href="http://redmine.nmid-plugins.de/attachments/download/344/nmidSmokeping_v1.04.zip">http://redmine.nmid-plugins.de/attachments/download/344/nmidSmokeping_v1.04.zip</a> -O smokeping.zip</pre>

<pre>wget <a href="http://docs.cacti.net/_media/plugin:nmidphpip-latest.tgz">http://docs.cacti.net/_media/plugin:nmidphpip-latest.tgz</a> -O phpip.tgz</pre>

<pre>wget <a href="http://www.network-weathermap.com/files/php-weathermap-0.97a.zip">http://www.network-weathermap.com/files/php-weathermap-0.97a.zip</a> -O weathermap.zip</pre>

<pre>wget <a href="http://docs.cacti.net/_media/userplugin:manage-0.6.2.zip">http://docs.cacti.net/_media/userplugin:manage-0.6.2.zip</a> -O manage.zip</pre>

<pre>wget <a href="http://redmine.nmid-plugins.de/attachments/download/342/nmidWebService_2.07_wZend.tgz">http://redmine.nmid-plugins.de/attachments/download/342/nmidWebService_2.07_wZend.tgz</a> -O webservice.zip</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./aggregate.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./routerconfig.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./realtime.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./discovery.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./settings.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./thold.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./superlinks.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./mactrack.tgz</pre>

<pre>sudo tar -C /var/www/cacti/plugins -xzvf ./flowview.tgz</pre>

<pre>sudo unzip ./manage.zip -d /var/www/cacti/plugins/</pre>

<pre>sudo unzip ./weathermap.zip -d /var/www/cacti/plugins/</pre>

<pre>sudo unzip ./smokeping.zip -d /var/www/cacti/plugins/</pre>

<pre>Modify /var/www/cacti/plugins/weathermap/editor.php to enable the editor for weathermap.</pre>

<pre>sudo nano /var/www/cacti/plugins/weathermap/editor.php</pre>

<pre>$ENABLED=true;</pre>

<pre>sudo mkdir /var/netflow</pre>

<pre>sudo mkdir /var/netflow/flows</pre>

<pre>sudo mkdir /var/netflow/flows/completed</pre>

<pre>sudo mkdir /var/www/cacti/plugins/routerconfigs/backups</pre>

<pre>sudo mkdir /var/www/cacti/plugins/cache</pre>

<pre>sudo chown -R www-data:www-data /var/www/cacti/plugins</pre>

<pre>sudo chmod -R 777 /var/www/cacti/plugins</pre>

Go to http://<IP-Address>/cacti/plugins.php and enable your plugins

Go to http://<IP-Address>/cacti/settings.php and in the &#8220;Misc&#8221; tab change your settings for the realtime cache directory to be /var/www/cacti/plugins/cache/ (consequently, this is also where you go to setup the discover plugin subnets)

Go to http://<IP-Address>/cacti/user_admin.php, select the admin user, then under realm permissions ensure that the MacTracker items are selected.

[<img class="aligncenter size-medium wp-image-674" title="cacti-setting1" alt="" src="/wp-content/uploads/2012/11/cacti-setting13.jpg?resize=300%2C100" width="300" height="100" srcset="/wp-content/uploads/2012/11/cacti-setting13.jpg?resize=300%2C100 300w, wp-content/uploads/2012/11/cacti-setting13.jpg?w=426 426w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]When all is said and done you should have a bunch of extra Cacti areas to play around in and mess up (that is up to you to figure out and fix).

[<img class="aligncenter size-medium wp-image-675" title="cacti-setting2" alt="" src="/wp-content/uploads/2012/11/cacti-setting2.jpg?resize=300%2C50" width="300" height="50" srcset="/wp-content/uploads/2012/11/cacti-setting2.jpg?resize=300%2C50 300w, wp-content/uploads/2012/11/cacti-setting2.jpg?w=646 646w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][4]

## 360-FAAR

**Site:** <http://www.360analytics.co.uk/360faar/>

### Purpose

This nifty script is self-described in the following excerpt from its readme.txt file,

> 360-FAAR (Firewall Analysis Audit and Repair) is an offline, command line, Perl firewall policy manipulation tool to filter, compare to logs, merge, translate and output firewall commands for new policies, in Checkpoint dbedit, Cisco PIX/ASA or ScreenOS commands, and its one file!
> 
> Read Policy and Logs for:
> 
> Checkpoint FW1 (in odumper.csv / logexport format),
> 
> Netscreen ScreenOS (in get config / syslog format),
> 
> Cisco ASA (show run / syslog format),
> 
> 360-FAAR uses both inclusive and exclusive CIDR and text filters, permitting you to split large policies into smaller ones for virtualizations at the same time as removing unused connectivity.
> 
> 360-FAAR supports, policy to log association, object translation, rulebase reordering and simplification, rule moves and duplicate matching automatically. Allowing you to seamlessly move rules to where you need them.
> 
> TRY: &#8216;print&#8217; mode. One command, and spreadsheet for your audit needs!

I&#8217;ll be honest and say I&#8217;ve yet had the opportunity to use the script but it sounds pretty cool in what it does. Also, the developers are constantly updating it so if you do use this on a regular basis you may want to follow the project on freecode.com.

### Setup

FAAR is just a perl script so there is not much needed besides some perl libraries and a location to put the script. I&#8217;ve been putting the single use command line tools in the ~/Applications directory up to this point so that is where FAAR is going to go.

<pre>sudo apt-get install libperl4-corelibs-perl</pre>

<pre>cd ~/Downloads/</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/faar/360AnalyticsLtd-0.2.4.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ffaar%2F&ts=1337551221&use_mirror=iweb">http://downloads.sourceforge.net/project/faar/360AnalyticsLtd-0.2.4.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ffaar%2F&ts=1337551221&use_mirror=iweb</a>' -O faar.zip</pre>

<pre>unzip ./faar.zip</pre>

<pre>mv ./360AnalyticsLtd ~/Applications/faar</pre>

<pre>rm -rf ./__MACOSX</pre>

## Gestioip

**Site:** <http://www.gestioip.net/>

### Purpose

I don&#8217;t believe an IP address management application is really related to the discovery type nature of the appliance but I thought I&#8217;d include one regardless. This is due to how many people I see still using spreadsheets to manage their network IP addresses.

I was initially going to setup phpip but I tried and tried and, for the life of me, couldn&#8217;t get phpip to work. (This is likely due to how massively aged and ignored the project has become.) Thus my switch to Gestioip for IP address management.

After getting everything configured I was pleasantly surprised to find additional IPv6 migration and configuration features I&#8217;ve not seen in any other product.  This automatically boosted the awesomeness of this free tool in my head and therefore it gets a spotlight in my toolkit.

GestioIP terms itself as;

> GestióIP is an automated, Web based **IPv4/IPv6 address management (IPAM) software**. It features powerful network discovery functions and offers search and filter functions for both networks and host, permitting Internet Search Engine equivalent expressions. This lets you find the information that administrators frequently need easily and quickly. GestióIP also incorporates an automated VLAN management system.

### Setup

<pre>cd ~/Downloads</pre>

<pre>sudo apt-get install libapache2-mod-perl2</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/gestioip/gestioip/gestioip_3.0.tar.gz?r=http%3A%2F%2Fwww.gestioip.net%2Fip-address-management-software.html&ts=1337708590&use_mirror=softlayer">http://downloads.sourceforge.net/project/gestioip/gestioip/gestioip_3.0.tar.gz?r=http%3A%2F%2Fwww.gestioip.net%2Fip-address-management-software.html&ts=1337708590&use_mirror=softlayer</a>' -O gestioip.tar.gz</pre>

<pre>tar -xzvf ./gestioip.tar.gz</pre>

<pre>mv ./gestioip_3.0/ ./gestioip</pre>

<pre>sudo su -</pre>

<pre>cd /home/netcollect/Downloads/gestioip/</pre>

<pre>./setup_gestioip.sh</pre>

Accept all the default prompts and follow the directions for creating the read-only and admin users and everything should &#8220;just work&#8221; when it completes.

Read-Only: gipoper/admin

Admin User: gipadmin/admin

Now go to http://<IP-Address>/gestioip/install/ and run through the database install process. I used the following information to complete the installer:

[<img class="aligncenter size-medium wp-image-676" title="gestioip-1" alt="" src="/wp-content/uploads/2012/11/gestioip-1.jpg?resize=234%2C300" width="234" height="300" srcset="/wp-content/uploads/2012/11/gestioip-1.jpg?resize=234%2C300 234w, /wp-content/uploads/2012/11/gestioip-1.jpg?w=344 344w" sizes="(max-width: 234px) 100vw, 234px" data-recalc-dims="1" />][5]

Although I got all green Oks at this step the next step failed with a database access error. To get around this I manually assigned the rights for the gestioip user on the gestioip database like so:

<pre>mysql -u root -p</pre>

<mysql root password>

<pre>GRANT ALL PRIVILEGES ON gestioip.* TO 'gestioip'@'localhost' IDENTIFIED BY 'gestioip';</pre>

<pre>QUIT</pre>

I was then able to continue configuration. I used a basic main office site and the pre-defined network categories:

[<img class="aligncenter size-medium wp-image-677" title="gestioip-2" alt="" src="/wp-content/uploads/2012/11/gestioip-2.jpg?resize=300%2C296" width="300" height="296" srcset="/wp-content/uploads/2012/11/gestioip-2.jpg?resize=300%2C296 300w, wp-content/uploads/2012/11/gestioip-2.jpg?w=570 570w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][6]

Finally remove the install directory and then go ahead and access for freshly installed, web-based, IP address management solution.

<pre>sudo rm -r /var/www/gestioip/install</pre>

### GestioIP Usage

When first using GestioIP you will probably want to create a root network per physical site which contains a supernet of all of your subnets then add all the routed subnets. If this is not your network you can still use the GestioIP application for some rudimentary discovery.

There are some cool import/export functions you can use as well:

[<img class="aligncenter size-full wp-image-678" title="gestioip-3" alt="" src="/wp-content/uploads/2012/11/gestioip-3.jpg?resize=300%2C214" width="300" height="214" data-recalc-dims="1" />][7]

Under the manage -> manage GestioIP at the very bottom of the screen is where you go to reset the database for a new client site.

[<img class="aligncenter size-full wp-image-679" title="gestioip-4" alt="" src="/wp-content/uploads/2012/11/gestioip-4.jpg?resize=203%2C123" width="203" height="123" data-recalc-dims="1" />][8][<img class="aligncenter size-medium wp-image-680" title="gestioip-5" alt="" src="/wp-content/uploads/2012/11/gestioip-5.jpg?resize=300%2C99" width="300" height="99" srcset="/wp-content/uploads/2012/11/gestioip-5.jpg?resize=300%2C99 300w, wp-content/uploads/2012/11/gestioip-5.jpg?w=518 518w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][9]

**GestioIP Extra Surprise Feature**

One of the coolest features (which I didn&#8217;t realize I was getting until I started poking around the app) is an IPv6 Address Planner. The planner takes you from beginning to end in creating a hierarchy for your organization. There are two options when planning. Both options start out with you putting in your IPv6 address block.

[<img class="aligncenter size-medium wp-image-681" title="gestioip-6" alt="" src="/wp-content/uploads/2012/11/gestioip-6.jpg?resize=300%2C113" width="300" height="113" srcset="/wp-content/uploads/2012/11/gestioip-6.jpg?resize=300%2C113 300w, wp-content/uploads/2012/11/gestioip-6.jpg?w=823 823w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][10]

The second option helps you come up with a new site plan based on number of sites and category of IP addresses (prod, dev, test, et cetera). This can be quite valuable in helping plan your network and preventing IP subnet fragmentation moving forward. Below is the output for creating a new IPv6 address plan for one site that contains corp, dev, and test categories and planning for 2 sites (each having 4 root networks being reserved).

[<img class="aligncenter size-medium wp-image-682" title="gestioip-7" alt="" src="/wp-content/uploads/2012/11/gestioip-7.jpg?resize=300%2C82" width="300" height="82" srcset="/wp-content/uploads/2012/11/gestioip-7.jpg?resize=300%2C82 300w, wp-content/uploads/2012/11/gestioip-7.jpg?w=948 948w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][11][<img class="aligncenter size-medium wp-image-683" title="gestioip-8" alt="" src="/wp-content/uploads/2012/11/gestioip-8.jpg?resize=300%2C112" width="300" height="112" srcset="/wp-content/uploads/2012/11/gestioip-8.jpg?resize=300%2C112 300w, wp-content/uploads/2012/11/gestioip-8.jpg?w=617 617w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][12][<img class="aligncenter size-medium wp-image-684" title="gestioip-9" alt="" src="/wp-content/uploads/2012/11/gestioip-9.jpg?resize=300%2C212" width="300" height="212" srcset="/wp-content/uploads/2012/11/gestioip-9.jpg?resize=300%2C212 300w, /wp-content/uploads/2012/11/gestioip-9.jpg?w=862 862w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][13]

I wish I could say I used this to plan an IPv6 migration but I&#8217;d be lying if I did. But I will say (from staying intellectually current in the industry) that this is a feature which I would use if performing such an upgrade. This is top-notch stuff for a free tool. Definitely worth checking out.

## NETDISCO

**Site:** http://www.netdisco.org

### Purpose

Netdisco terms itself as;

> &#8230; an Open Source web-based network management tool first released publically in 2003. The target users are large corporate and university networks administrators. Data is collected into a Postgres database using SNMP and presented with a clean web interface using Mason.
> 
> Configuration information and connection data for network devices are retrieved via SNMP. Data is stored using a SQL database for scalability and speed. Layer-2 topology protocols such as CDP and LLDP provide automatic discovery of the network topology. Here are some of the favorite uses for this tool:
> 
>   * **Locate** a machine on the network by MAC or IP and show the switch port it lives at.
>   * **Turn Off** a switch port while leaving an audit trail. Admins log why a port was shut down.
>   * **Inventory** your network hardware by model, vendor, switch-card, firmware and operating system.
>   * **Report** on IP address and switch port usage: historical and current.
>   * **Pretty pictures** of your network.
> 
> Netdisco gets all its data, including topology information, with SNMP polls and DNS queries. It does not use CLI access and has no need for privilege passwords.

### Setup

A long time ago I had setup netdisco and recall the install process to be rather painful. Thus I had avoided it for quite a while. Since I&#8217;m making a discovery appliance I&#8217;d be doing netdisco a great disservice by not including it along for the ride. I chose the cheesy way of doing the install and just used apt at first but it wasn’t up to date so I uninstalled and reinstalled by hand. It was just as painful to get working this time as it was the last \*sigh\*. I believe I captured the right steps to get netdisco working on my VM but if I missed something please let me know.

I used a good portion of the [installer script another person posted online][14].

<pre>cd ~/Downloads</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/netdisco/netdisco/1.1/netdisco-1.1_with_mibs.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetdisco%2Ffiles%2Fnetdisco%2F1.1%2F&ts=1337715093&use_mirror=softlayer">http://downloads.sourceforge.net/project/netdisco/netdisco/1.1/netdisco-1.1_with_mibs.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetdisco%2Ffiles%2Fnetdisco%2F1.1%2F&ts=1337715093&use_mirror=softlayer</a>' -O netdisco.tar.gz</pre>

<pre>tar xzvf netdisco.tar.gz</pre>

<pre>sudo mkdir -p /usr/local/netdisco</pre>

<pre>sudo mv netdisco-1.1/* /usr/local/netdisco</pre>

<pre>sudo useradd -d <strong>/</strong>usr<strong>/</strong>local<strong>/</strong>netdisco netdisco</pre>

<pre>sudo chown -R netdisco:netdisco /usr/local/netdisco</pre>

<pre>sudo cp /etc/postgresql/9.1/main/pg_hba.conf /etc/postgresql/9.1/main/pg_hba.conf .orig</pre>

<pre>sudo su -</pre>

<pre>echo '' &gt;&gt; /etc/postgresql/9.1/main/pg_hba.conf</pre>

<pre>echo 'host    netdisco        netdisco        127.0.0.1       255.255.255.255         trust' &gt;&gt; /etc/postgresql/9.1/main/pg_hba.conf</pre>

<pre>echo 'local   netdisco        netdisco        trust' &gt;&gt; /etc/postgresql/9.1/main/pg_hba.conf</pre>

<pre>/etc/init.d/postgresql restart</pre>

<pre>/usr/local/netdisco/sql/pg --init</pre>

<pre>crontab -u netdisco /usr/local/netdisco/netdisco.crontab</pre>

<pre>ln -s /usr/local/netdisco/bin/netdisco_daemon /etc/init.d/netdisco</pre>

<pre>update-rc.d netdisco defaults</pre>

<pre>echo "Include /usr/local/netdisco/netdisco_apache.conf" &gt; /etc/apache2/conf.d/netdisco.conf</pre>

<pre>echo "Include /usr/local/netdisco/netdisco_apache_dir.conf" &gt;&gt; /etc/apache2/conf.d/netdisco.conf</pre>

<pre>perl -pi -e 's/CHANGEME/netdisco/g' /etc/netdisco/netdisco_apache2.conf</pre>

<pre>apt-get install postgresql apache2 graphviz libnet-snmp-perl libapache2-mod-perl2 libapache-session-wrapper-perl libhtml-mason-perl libdbd-pg-perl libgraphviz-perl libio-zlib-perl libapache2-request-perl libnet-nbname-perl libsnmp-info-perl libapache-dbi-perl libmasonx-request-withapachesession-perl libparallel-forkmanager-perl libgraph-perl</pre>

<pre>a2enmod apreq</pre>

<pre>chmod 660 /usr/local/netdisco/*.conf</pre>

<pre>chgrp netdisco /usr/local/netdisco/*.</pre>

<pre>service apache2 restart</pre>

<pre>/usr/local/netdisco/netdisco -u admin</pre>

<pre>&lt;enter password, I used just admin&gt;</pre>

<pre>&lt;enter yes for each option&gt;</pre>

<pre>cd /usr/local/netdisco</pre>

<pre>make oui</pre>

<pre>/etc/init.d/netdisco start</pre>

<pre>exit</pre>

Finally, go through and modify the config file for your environment:

<pre>nano /usr/local/netdisco/netdisco.conf</pre>

Access the netdisco interface at http://<IP-Address>/netdisco with admin/admin

Among other excellent features there are some cool reports for discovery:

[<img class="aligncenter size-medium wp-image-685" title="netdisco-1" alt="" src="/wp-content/uploads/2012/11/netdisco-1.jpg?resize=300%2C201" width="300" height="201" srcset="/wp-content/uploads/2012/11/netdisco-1.jpg?resize=300%2C201 300w, wp-content/uploads/2012/11/netdisco-1.jpg?w=325 325w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][15]

## NTD &#8211; Network Topology Diagrammer

**Site:** <http://www.sivann.gr/software.php#ntd>

### Purpose

I stumbled across this one while I was looking at another software product this kind programmer gives away for free, ITDB. I&#8217;m going to wait for the auto-discover feature for that product before installing. But NTD looks worthy to setup and use right now. Here is how it is done.

### Setup

<pre>cd</pre>

<pre>cd ./Downloads</pre>

<pre>wget <a href="http://www.sivann.gr/software/ntd-0.4.tar.gz">http://www.sivann.gr/software/ntd-0.4.tar.gz</a></pre>

<pre>tar xzvf ./ntd-0.4.tar.gz</pre>

<pre>sudo mv ./ntd /var/www</pre>

<pre>sudo chown -R www-data.www-data /var/www/ntd</pre>

<pre>sudo chmod -R 777 /var/www/ntd/</pre>

<pre>sudo perl -pi -e 's/public/<strong><em>&lt;your-snmp-string&gt;</em></strong>/g' /var/www/ntd/doc/snmp.txt</pre>

<pre>sudo perl -pi -e 's/public/<strong><em>&lt;your-snmp-string&gt;</em></strong>/g' /var/www/ntd/ntd.php</pre>

<pre>sudo perl -pi -e 's/public/<strong><em>&lt;your-snmp-string&gt;</em></strong>/g' /var/www/ntd/ntd.phps</pre>

Then access via a browser by going to http://<IP-Address>/ntd/ntd.php, put in your default gateway, click run, and wait a bit for your results.

[<img class="aligncenter size-medium wp-image-686" title="ndt-1" alt="" src="/wp-content/uploads/2012/11/ndt-1.jpg?resize=300%2C220" width="300" height="220" srcset="/wp-content/uploads/2012/11/ndt-1.jpg?resize=300%2C220 300w, wp-content/uploads/2012/11/ndt-1.jpg?w=681 681w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][16]

The png output file never seems to generate but it does generate a [graphviz][17] file which you can use to create some pretty nice looking diagrams.

[<img class="aligncenter size-medium wp-image-687" title="ndt-2" alt="" src="/wp-content/uploads/2012/11/ndt-2.jpg?resize=300%2C233" width="300" height="233" srcset="/wp-content/uploads/2012/11/ndt-2.jpg?resize=300%2C233 300w, /wp-content/uploads/2012/11/ndt-2.jpg?w=695 695w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][18]

## SMART &#8211; Safe Mapping And Reporting Tool

**Site:** <http://safemap.sourceforge.net/>

### Purpose

This one flew right under my radar when it was released. To top it off, it was released by Cisco then promptly dumped for whatever reason (looks like the team responsible for it got dissolved internally at Cisco).

SMART is a passive network visualization tool. It is self-proclaimed as:

> The Safe Mapping and Reporting Tool (SMART) is a completely passive network flow visualization tool for small to medium sized IP networks featuring device and operating system identification and network service enumeration.
> 
> …
> 
> SMART can also process packet capture files from tools like [tcpdump][19] or [ethereal][20]/[wireshark][21] in pcap format, adding network flow visualization to your forensic toolkit.

### Setup

<pre>cd</pre>

<pre>cd ./Downloads</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/safemap/safemap/1.0/smart-1.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsafemap%2F&ts=1353448527&use_mirror=iweb">http://downloads.sourceforge.net/project/safemap/safemap/1.0/smart-1.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsafemap%2F&ts=1353448527&use_mirror=iweb</a>' -O smart-1.0.tar.gz</pre>

<pre>tar xzvf ./smart-1.0.tar.gz</pre>

<pre>sudo mv ./smart-1.0 /var/www/smart/</pre>

<pre>sudo chown -R www-data.www-data /var/www/smart/</pre>

<pre>cd /var/www/smart</pre>

<pre>sudo apt-get install libpcap-dev</pre>

<pre>sudo perl ./Build.PL</pre>

Then to run the packet capture:

> On linux systems you will need to be root to run smart.pl in promiscuous mode to capture packets from your LAN (-p option).
> 
> As a typical use example, suppose your local network includes the 192.168.x.x and 10.x.x.x netblocks. From a linux host, you would execute smart.pl as follows:
> 
> <pre>sudo ./smart.pl -N "My Net" -x -p -d -i eth0 -t 20 -L "^192\.168\.|^10\."</pre>
> 
> &#8211; This would label web pages produced by SMART with &#8220;My Net&#8221; (-N)
> 
> &#8211; The flowlog would be saved in XML format (-x)
> 
> &#8211; Packets would be captured in promiscous mode (-p)
> 
> &#8211; Debug mode would be enabled (-d)
> 
> &#8211; eth0 would be the packet capture interface (-i)
> 
> &#8211; The flowlog and the web pages would be updated every 20 secs (-t)
> 
> &#8211; The 192.168.x.x and 10.x.x.x netblocks would be considered the local &#8220;LAN&#8221; for the Lan Focus displays in the web interface.

You can also specify -r <filename> to just read from a pcap file. The interactive website does require the Adobe SVG Viewer be installed on your computer. Some output just from my home network:

[<img class="aligncenter size-medium wp-image-688" title="Smart-1" alt="" src="/wp-content/uploads/2012/11/Smart-1.jpg?resize=300%2C169" width="300" height="169" srcset="/wp-content/uploads/2012/11/Smart-1.jpg?resize=300%2C169 300w, wp-content/uploads/2012/11/Smart-1.jpg?w=907 907w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][22]

# Extras

Here is a list of extras I added into the mix for other network management tasks. Some do monitoring, others are for maintaining documentation. They are not really discovery related but worth having if you are in a more permanent environment.

## phpFileManager

**Site:** <http://phpfm.sourceforge.net/>

### Purpose

I set this up mainly to access the files within the netcollect user home directory. I know there are other flashier web based file managers but this is easy and it works for my purposes. Here is how to set it up.

### Setup

<pre>cd ~/Downloads</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/phpfm/phpFileManager/version%200.9.5/phpFileManager-0.9.5.zip?r=http%3A%2F%2Fphpfm.sourceforge.net%2F&ts=1352141782&use_mirror=iweb">http://downloads.sourceforge.net/project/phpfm/phpFileManager/version%200.9.5/phpFileManager-0.9.5.zip?r=http%3A%2F%2Fphpfm.sourceforge.net%2F&ts=1352141782&use_mirror=iweb</a>' -O phpFileManager-0.9.5.zip</pre>

<pre>unzip ./phpFileManager-0.9.5.zip</pre>

<pre>mv  ./index.php ../</pre>

<pre>sudo adduser www-data netcollect</pre>

<pre>sudo nano /etc/apache2/sites-available/phpfilemanager</pre>

<pre>&lt;VirtualHost *:82&gt;</pre>

<pre>  DocumentRoot /home/netcollect</pre>

<pre>  &lt;Directory /home/netcollect/&gt;</pre>

<pre>        AllowOverride All</pre>

<pre>        Options FollowSymLinks MultiViews Indexes</pre>

<pre>        Order allow,deny</pre>

<pre>        allow from all</pre>

<pre>  &lt;/Directory&gt;</pre>

<pre>&lt;/VirtualHost&gt;</pre>

Add the following to  /etc/apache2/ports.conf

Listen 82

<pre>sudo a2ensite phpfilemanager</pre>

<pre>sudo /etc/init.d/apache2 restart</pre>

Then access the web file manager by going to http://<IP-Address>:82/

## Shinkin

**Site:** <http://www.shinken-monitoring.org/>

### Purpose

Shinken describes itself thusly;

> Shinken is an open source Nagios like tool, redesigned and rewritten from scratch. Its main goal is to meet today’s system monitoring requirements while still allowing compatibility to Nagios®

### Setup

<pre>cd ~/Downloads</pre>

<pre>wget <a href="http://shinken-monitoring.org/pub/shinken-1.0.1.tar.gz">http://shinken-monitoring.org/pub/shinken-1.0.1.tar.gz</a> -O shinken.tar.gz</pre>

<pre>tar xzvf ./shinken.tar.gz</pre>

<pre>cd ./shinken-1.0.1</pre>

<pre>sudo perl -pi -e 's/1.1.12p6/1.2.0p3/g' ./install.d/shinken.conf</pre>

<pre>sudo ./install -i && sudo ./install -p nagios-plugins && sudo ./install -p check_mem && sudo ./install -p manubulon && sudo ./install -p multisite && sudo ./install -p pnp4nagios && sudo ./install -p nagvis && sudo ./install –p multisite</pre>

<pre>sudo /etc/init.d/shinken start</pre>

You then can login at http://<IP-Address>:7767 with admin/admin

Note that, despite the simple installation, Shinken is a very comprehensive program with logs of options for discovery, monitoring, and integration. You will really want to get more info on configuring this bad boy from their site.

## RackTables

**Site:** <http://racktables.org/>

### Purpose

This is not really a discovery related addition but can be nice to have in your environment for proactive infrastructure documentation. RackTables as defined by its creators:

> Racktables is a nifty and robust solution for datacenter and server room asset management. It helps document hardware assets, network addresses, space in racks, networks configuration and much much more!

### Setup

<pre>sudo apt-get install php5-cgi php5-curl</pre>

<pre>cd ~</pre>

<pre>cd ./Downloads</pre>

<pre>wget '<a href="http://downloads.sourceforge.net/project/racktables/RackTables-0.20.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fracktables%2Ffiles%2F&ts=1353701797&use_mirror=iweb">http://downloads.sourceforge.net/project/racktables/RackTables-0.20.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fracktables%2Ffiles%2F&ts=1353701797&use_mirror=iweb</a>' -O RackTables-0.20.1.tar.gz</pre>

<pre>tar xzvf RackTables-0.20.1.tar.gz</pre>

<pre>cd  ./RackTables-0.20.1</pre>

<pre>sudo mv ./RackTables-0.20.1 /var/www/racktables</pre>

<pre>sudo touch '/var/www/racktables/wwwroot/inc/secret.php'
sudo chmod 666 '/var/www/racktables/wwwroot/inc/secret.php'</pre>

<pre>sudo chown -R www-data.www-data /var/www/racktables/
mysql -u root -p</pre>

<mysql root password>

<pre>CREATE DATABASE racktables;
GRANT ALL PRIVILEGES ON racktables.* TO 'racktablesuser'@'localhost' IDENTIFIED BY 'racktablesuser';
QUIT</pre>

Go to the following site to start the installer: <http://192.168.1.148/racktables/wwwroot/?module=installer>

Follow the install, ignore the warnings and use the database of racktables with the user and password of racktables/racktables. Set whatever admin password you like. I&#8217;m super original so I just set it to be racktables. After this is done you can access and setup Racktables.

## Netdot

**Site:** <https://osl.uoregon.edu/redmine/projects/netdot>

### Purpose

Netdot developers say that Netdot is:

> Network Documentation Tool project
> 
> Netdot is an open source tool designed to help network administrators collect, organize and maintain network documentation.

### Setup

I&#8217;ve really wanted to try this one out for years now but I&#8217;ve never been able to successfully get it running…and I still cannot unfortunately.  Maybe you will have better luck with directions [at this post online][23]. I went through the following steps before I got stuck at the final stages of the install 🙁 I&#8217;m going to note this to be possibly revisited at a future date as it really does seem to be a cool networking tool.

# Conclusion

I hope this article broadens the consciousness of some of the great open source tools at the disposal of today’s network analysts and administrators.

 [1]: /2012/04/08/create-your-own-network-assessment-appliance/ "Create your own network assessment appliance"
 [2]: http://www.rrdtool.org
 [3]: wp-content/uploads/2012/11/cacti-setting13.jpg
 [4]: wp-content/uploads/2012/11/cacti-setting2.jpg
 [5]: /wp-content/uploads/2012/11/gestioip-1.jpg
 [6]: wp-content/uploads/2012/11/gestioip-2.jpg
 [7]: wp-content/uploads/2012/11/gestioip-3.jpg
 [8]: /wp-content/uploads/2012/11/gestioip-4.jpg
 [9]: wp-content/uploads/2012/11/gestioip-5.jpg
 [10]: wp-content/uploads/2012/11/gestioip-6.jpg
 [11]: wp-content/uploads/2012/11/gestioip-7.jpg
 [12]: wp-content/uploads/2012/11/gestioip-8.jpg
 [13]: /wp-content/uploads/2012/11/gestioip-9.jpg
 [14]: http://www.mattvsworld.com/blog/2010/04/install-netdisco-on-ubuntu-from-source/
 [15]: wp-content/uploads/2012/11/netdisco-1.jpg
 [16]: wp-content/uploads/2012/11/ndt-1.jpg
 [17]: http://www.graphviz.org/Download..php
 [18]: /wp-content/uploads/2012/11/ndt-2.jpg
 [19]: http://www.tcpdump.org
 [20]: http://ethereal.com/
 [21]: http://wireshark.org
 [22]: wp-content/uploads/2012/11/Smart-1.jpg
 [23]: https://osl.uoregon.edu/redmine/projects/netdot/wiki/Installing_Under_Ubuntu_10041_Server