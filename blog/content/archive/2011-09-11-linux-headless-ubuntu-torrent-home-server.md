---
title: 'Linux: Headless Ubuntu Torrent Home Server'
author: Zachary Loeber
type: post
date: 2011-09-11T21:45:15+00:00
excerpt: 'Setup a headless ubuntu linux torrent media server. When done you will have the following installed; Peer Guardian, PS3 Media Server,  Transmission, Torrentwatch-X (integrated with transmission), Mollify, Samba, and Webmin.'
url: /blog/2011/09/11/linux-headless-ubuntu-torrent-home-server/
wordbooker_options:
  - 'a:10:{s:18:"wordbook_noncename";s:10:"6fca0a9ba3";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";s:17:"wordbook_new_post";s:1:"0";}'
wordbooker_extract:
  - So it got to that time of the year where I feel the itch to upgrade my aging home server. I assessed the situation and realized that, for what it does, my current server does not need any kind of hardware upgrade. So I just decided to rebuild it with U ...
categories:
  - Linux
  - Other
  - System Administration
  - Ubuntu
tags:
  - Linux
  - Other
  - Security
  - System Administration
  - Ubuntu

---
So it got to that time of the year where I feel the itch to upgrade my aging home server. I assessed the situation and realized that, for what it does, my current server does not need any kind of hardware upgrade. So I just decided to rebuild it with Ubuntu 11.04 64 bit and change up the server software a bit to be more accessible to my wife as well as to be a bit more modern (torrentflux and derivatives have been dead for a while now).

<!--more-->

## Preface

In this rebuild I wanted to make the services on the server more accessible for my wife. So my software selection is a bit more cohesive as I want all the services to be accessible to more than just the technically inclined. I also wanted her to be able to download missed TV shows without my help should she find the need to do so.

Software I chose to install:

  * Peer Guardian for Linux &#8211; Blocks IP addresses from known haters and other groups of your choice.
  * <del>Mediatomb</del> PS3 Media Server &#8211; A upnp server for playing movies and other media
  * Transmission &#8211; A pretty cool bittorrent client
  * Torrentwatch-x &#8211; Web based RSS tracker for bittorrents, integrates with transmission
  * Mollify &#8211; A simple web based file browser
  * Samba &#8211; For windows workstation integration
  * Webmin &#8211; I didn&#8217;t want to mess with a manual samba configuration so I set this up to simplify things 🙂

## Initial Server Install

As I refuse to just post a bunch of screenshots of pressing &#8220;next&#8221; I&#8217;m going to skip the base install documentation. The brief rundown of what to do is to install Ubuntu server 11.04 64 bit, do not select drive encryption, select &#8220;OpenSSH server&#8221;, &#8220;LAMP Server&#8221;, and &#8220;SAMBA file server&#8221; for the core software. If you flubbed this up for whatever reason you can always run &#8220;sudo tasksel&#8221; to select these metapackages later on.

I started out with some generic apps. For whatever reason add-apt-repository was not available in the 64bit server version of ubuntu 11.04. Install this to make that handy command available again. I add in rkhunter, screen and htop cause I like them 🙂 We also install ntp to update our time automatically:

<pre>sudo apt-get install python-software-properties ntp ntpdate rkhunter screen htop</pre>

I also modified the base apt repository list: Uncomment the following in /etc/apt/sources.list (sudo nano /etc/apt/sources.list):

<pre>deb http://archive.canonical.com/ubuntu natty partner
deb-src http://archive.canonical.com/ubuntu natty partner</pre>

Update your system and make our working directory used in the rest of this post. All scripting and commands posted are assuming that this Downloads folder exists, should you do things any other way then you will have to keep that in mind throughout the post and modify things as needed. Adding to that, the whole post is not simply a copy and paste fully scripted out procedure so do things intelligently and with fair warning that your results may vary based on your environment and technical acuity:

<pre>sudo apt-get update
sudo apt-get upgrade
cd ~
mkdir Downloads</pre>

## Peer Guardian for Linux Install

Install the repository and the software. You will be asked a series of questions. You can skip them and modify the pglcmd.conf file directly afterwards if you like. I do recommend you be careful when selecting your block lists. The default should be fine but you may want to add a few more from the list when given the option:

<pre>sudo apt-add-repository ppa:jre-phoenix</pre>

<pre>sudo apt-get update</pre>

<pre>sudo apt-get install pgld pglcmd</pre>

If you skipped or just chose the default wizards then update the default config file to allow services that have nothing to do with torrent traffic in and out of your server:

<pre>sudo cp /etc/pgl/pglcmd.conf ~</pre>

<pre>sudo sed -i 's/WHITE_TCP_OUT=""/WHITE_TCP_OUT="80 443 22"/' /etc/pgl/pglcmd.conf</pre>

<pre>sudo sed -i 's/WHITE_TCP_IN=""/WHITE_TCP_IN="80 443 22"/' /etc/pgl/pglcmd.conf</pre>

<pre>sudo sed -i 's/WHITE_IP_OUT=""/WHITE_IP_OUT="192.168.0.0\/16"/' /etc/pgl/pglcmd.conf</pre>

<pre>sudo sed -i 's/WHITE_IP_IN=""/WHITE_IP_IN="192.168.0.0\/16"/' /etc/pgl/pglcmd.conf</pre>

<pre>sudo /etc/init.d/pgl reload</pre>

If you ever find that an update makes PeerGuardian unable to be started run sudo dpkg-reconfigure &#8211;force pglcmd. Here is some extra information taken directly from pgl when it failed to start for me. Make of it what you will:

> If any blocklists are missing, they will be downloaded. This may take several
> 
> minutes. Please be patient and don&#8217;t abort. If you want to follow the update
> 
> process, then do in another terminal a
> 
> tail -f /var/log/pgl/pglcmd.log
> 
> The lists are saved to /var/spool/pgl/.
> 
> The installation of pglcmd will fail, if starting pgld fails. So if
> 
> downloading the blocklists fails temporarily, the installation will fail. In
> 
> this case you may turn the automatic starting off by setting in
> 
> /etc/pgl/pglcmd.conf:
> 
> INIT=&#8221;0&#8243;
> 
> Then complete the installation and turn the automatic start on again:
> 
> sudo dpkg-reconfigure &#8211;force pglcmd

## Transmission Install

This small guide  should get you going but you still have to look at enabling UPnP/NAT-PMP on your firewall. If you are running TomatoUSB (my new favorite) then go to port forwarding -> UPnP/NAT-PMP to enable this setting. (Note: I wrote this up with without explaining a whole lot, I was looking for something else entirely when I found this well written guide with good explanations on the settings: http://1000umbrellas.com/2010/10/04/updated-transmission-installationconfiguration-on-ubuntu-server).

First install Transmission. Create a new home for transmission, Note that we add the incomplete directory so if a torrent dies or gets interrupted it remains in that directory instead of mucking up your downloads directory. We enable this behavior later on. Make it so you can modify this directory and all its contents by simply being in the debian-transmission group (this coincides with a transmission umask setting we will make shortly). Enable ports 9091 and 51413 (if using ufw, by default this is not enabled and therefore not needed). Finally update the transmission configuration, you need to do this with the daemon entirely stopped or the configuration changes will get overwritten the next time you restart the services:

<pre>sudo add-apt-repository ppa:transmissionbt/ppa</pre>

<pre>sudo apt-get update</pre>

<pre>sudo apt-get install transmission-daemon</pre>

<pre>cd /home</pre>

<pre>sudo mkdir -p ./torrents/download</pre>

<pre>sudo mkdir ./torrents/upload</pre>

<pre>sudo mkdir ./torrents/incomplete</pre>

<pre>sudo chown -R debian-transmission:debian-transmission ./torrents</pre>

<pre>sudo chmod g+w -R ./torrents/</pre>

<pre>sudo ufw allow 9091</pre>

<pre>sudo ufw allow proto tcp to any port 49152:65535</pre>

<pre>sudo /etc/init.d/transmission-daemon stop</pre>

<pre>sudo nano /etc/transmission-daemon/settings.json</pre>

Replace the following lines to (optionally) set downloaded torrents umask so that members of the debian-transmission group can read and write completed torrents (so you don&#8217;t have to sudo to move and delete the files). Also, get rid of authentication and update to your new directory layout:

<pre>"download-dir": "/home/torrents/download",</pre>

<pre>"incomplete-dir": "/home/torrents/incomplete",</pre>

<pre>"incomplete-dir-enabled": true,</pre>

<pre>"rpc-authentication-required": false,</pre>

<pre>"rpc-whitelist": "127.0.0.1,192.168.*.*",</pre>

<pre>"rpc-username": "",</pre>

<pre>"rpc-password": "",</pre>

<pre>"umask": 2,</pre>

<pre>"port-forwarding-enabled": true,</pre>

<pre>"peer-port-random-on-start": true,</pre>

Add your primary user account to the transmission group, replace <username> with your own login ID:

<pre>sudo usermod -a -G debian-transmission &lt;username&gt;</pre>

Startup Transmisison:

<pre>sudo /etc/init.d/transmission-daemon start</pre>

Test Transmission by going to http://servername:9091/transmission/ and uploading a torrent of your choice. When it starts downloading and connecting to peers validate that our blocklist configuration is indeed working by checking the logs in real time:

<pre>watch tail -n20 /var/log/pgl/pgld.log</pre>

## Torrentwatch-X Install

Torrentwatch-X is a nifty web interface for tracking rss feeds which point to torrents for such things as TV shows. I set this up so if my wife needs to get some TV show she missed it is as simple as a few clicks in a browser to download. Below should get everything setup in a way that is integrated with your prior transmission install:

<pre>sudo apt-get install php-services-json php5-curl php5-cgi</pre>

<pre>cd ~/Downloads</pre>

<pre>wget http://torrentwatch-x.googlecode.com/files/TorrentWatchX-0.8.0.tar.gz -O torrentwatch-x.tar.gz</pre>

<pre>tar xzvf ./torrentwatch-x.tar.gz</pre>

<pre>sudo mv ./TorrentWatchX-0.8.0/ /var/www/torrentwatch-x/</pre>

<pre>sudo cp /var/www/torrentwatch-x/php/config.php.dist /var/www/torrentwatch-x/php/config.php</pre>

<pre>sudo mkdir /etc/torrentwatch</pre>

<pre>sudo chown www-data.www-data -R /etc/torrentwatch/</pre>

<pre>sudo usermod -a -G debian-transmission www-data</pre>

<pre>sudo mkdir /var/www/torrentwatch-x/download</pre>

<pre>sudo chown www-data.www-data -R /var/www/torrentwatch-x/</pre>

<pre>sudo su</pre>

<pre>echo '*/15 * * * * /usr/bin/php-cgi -q /var/www/torrentwatch-x/rss_dl.php -D &gt;/dev/null 2&gt;&1' &gt;&gt; /var/spool/cron/crontabs/root</pre>

<pre>exit</pre>

Modify /etc/torrentwatch/torrentwatch.config and replace the [Settings] area only with the following to integrate transmission with torrentwatch-x:

<pre>[Settings]</pre>

<pre>Episode Only = 0</pre>

<pre>Combine Feeds = 1</pre>

<pre>Transmission Login =</pre>

<pre>Transmission Password =</pre>

<pre>Transmission Host = localhost</pre>

<pre>Transmission Port = 9091</pre>

<pre>Transmission URI = /transmission/rpc</pre>

<pre>Watch Dir =</pre>

<pre>Download Dir = /home/torrents/download</pre>

<pre>Cache Dir = /var/www/torrentwatch-x/rss_cache/</pre>

<pre>TVDB Dir = /var/www/torrentwatch-x/tvdb_cache/</pre>

<pre>Save Torrents =</pre>

<pre>Run Torrentwatch = True</pre>

<pre>Client = Transmission</pre>

<pre>Verify Episode = 1</pre>

<pre>Only Newer = 1</pre>

<pre>Download Proper =</pre>

<pre>Default Feed All =</pre>

<pre>Deep Directories = 0</pre>

<pre>Require Episode Info = 1</pre>

<pre>Disable Hide List =</pre>

<pre>History = /var/www/torrentwatch-x/rss_cache/rss_dl.history</pre>

<pre>MatchStyle = regexp</pre>

<pre>FirstRun =</pre>

<pre>Extension = torrent</pre>

<pre>verbosity = 0</pre>

<pre>Default Seed Ratio = -1</pre>

<pre>Script =</pre>

<pre>Email Notifications =</pre>

<pre>SMTP Server = localhost</pre>

<pre>TimeZone = UTC</pre>

<pre>Email Address =</pre>

<pre>Episodes Only =</pre>

<pre>Hide Donate Button =</pre>

## Mollify Install

I opted for installing Mollify for my wife to be able to easily access the server files from any computer. Here is how to get it setup:

<pre>cd ~/Downloads</pre>

<pre>wget "http://www.mollify.org/download/latest.php" -O mollify_1.8.1.zip</pre>

<pre>unzip ./mollify_1.8.1.zip</pre>

<pre>sudo mv ./mollify /var/www/
sudo chown -R www-data.www-data /var/www/mollify/</pre>

<pre>sudo touch /var/www/mollify/backend/configuration.php</pre>

<pre>sudo nano /var/www/mollify/backend/configuration.php</pre>

Enter the following

<pre>&lt;?php</pre>

<pre>$$CONFIGURATION_TYPE = "mysql";</pre>

<pre>$DB_HOST = "localhost";</pre>

<pre>$DB_DATABASE = "mollify";</pre>

<pre>$DB_USER = "mollify";</pre>

<pre>$DB_PASSWORD = "MollifyPass";</pre>

<pre>$DB_PORT = "3306";</pre>

<pre>$DB_SOCKET = "/var/run/mysqld/mysqld.sock";</pre>

<pre>$DB_TABLE_PREFIX = "mollify_";</pre>

<pre>?&gt;</pre>

Create your database with whatever login and password you want to use:

<pre>mysql -u root -p</pre>

<pre>CREATE DATABASE mollify;</pre>

<pre>CREATE USER 'mollify'@'localhost' IDENTIFIED BY 'MollifyPass';</pre>

<pre>GRANT ALL PRIVILEGES ON mollify.* TO 'mollify'@'localhost' WITH GRANT OPTION;</pre>

Go to http://<servername>/mollify/backend/install/ to complete the mollify installation (basically select next then create an admin account admin/admin). Logon to http://<servername>/mollify/backend/admin/.

Select Published Folders on left, Click on the add folder button, Put in the path of /home/torrents/downloaded with the description of &#8220;Downloaded Torrents&#8221;, Select the new published path and then click on &#8220;Add Folder for New Users/Groups&#8221;, check your admin account. Give your wife the admin account or create a new one, up to you. Other configuration settings for mollify can be set manually, here is a link to possible options : http://code.google.com/p/mollify/wiki/ConfigurationAdditionalOptions. There are also example configurations at /var/www/mollify/backend/examples

## PS3 Media Server Installation

Originally I was going to use mediatomb but I was having all kinds of issues getting it working the way I wanted and the xml config file and extra scripts you would need to get it working well is a total pain in the rear to setup. I finally scratched the mediatomb idea and went with PS3 Media Server. It runs on java and is more memory intensive but I simply do not care at this point (last sentence said in a frustrated tone).  Besides someone already wrote an awesome script to automate the install 🙂

<pre>sudo apt-get install xvfb sudo ia32-libs mencoder ffmpeg mplayer vlc sun-java6-jre</pre>

<pre>sudo su -</pre>

<pre>wget -q --no-check-certificate https://svn.paissad.net/misc/stuffs/install_PMS.sh -O /tmp/install_PMS.sh && bash /tmp/install_PMS.sh</pre>

<pre>Xvfb :5 &</pre>

Double-check that your user name is still part of the admin group, I found for some reason it was not after running the install process (nano /etc/group, look for the admin group and make sure your account name is listed at the end of the line). Then start a new terminal session with your server with X11 forwarding set (ie. ssh -X yourserver). From here you you have to stop the service, edit your settings, and restart the service:

<pre>sudo /etc/init.d/pms-linux stop</pre>

<pre>sudo pms-linux &</pre>

Edit your settings so that you are streaming /home/torrents/download and /home/torrents/upload (or whatever directory you want to stream, I chose these two to be able to automatically stream downloaded torrents and uploaded content quickly). Save your settings, exit, start pms-linux:

<pre>sudo /etc/init.d/pms-linux start</pre>

You can now just access the simple web terminal to kick off rescans of your media folders should you find the need to do so. The site will be http://<servername>:5001/console/

## Webmin Installation

This isn&#8217;t really needed but I wanted to setup the /home/torrents/download directory to be accessible via samba and I did not want to deal with doing it all via command-line. So I opted for webmin&#8217;s samba module to do the configuration:

<pre>cd ~/Downloads</pre>

<pre>sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python</pre>

<pre>wget 'http://downloads.sourceforge.net/project/webadmin/webmin/1.560/webmin_1.560_all.deb?r=http%3A%2F%2Fsourceforge.net%2Fsettings%2Fmirror_choices%3Fprojectname%3Dwebadmin%26filename%3Dwebmin%2F1.560%2Fwebmin_1.560_all.deb&ts=1313790358&use_mirror=superb-sea2' -O webmin_1.560_all.deb</pre>

<pre>sudo dpkg -i ./webmin_1.560_all.deb</pre>

<pre>sudo ufw allow 10000</pre>

<pre>sudo /usr/share/webmin/changepass.pl /etc/webmin root &lt;yourpass&gt;</pre>

You can now logon to your webmin interface by going to https://<servername>:10000/ and using <your username>/<yourpass>. If this does not work then use root/<yourpass>, select webmin -> Webmin Users -> Convert Unix Users -> select your username and select to convert now. Finally, share out any files/folders that you wish to share using the samba plugin within webmin.

&nbsp;