---
title: Run Updates = Rocket Science
author: Zachary Loeber
type: post
date: 2010-11-05T02:58:44+00:00
url: /blog/2010/11/04/run-updates-rocket-science/
categories:
  - Microsoft
  - Networking
  - Office Communicator Server
  - System Administration

---
So, I just recently tried to do some basic updates for ocs 2007 R2 by running the venerable &#8220;serverupdateinstaller.exe&#8221; found <a title="HERE" href="http://www.microsoft.com/downloads/en/details.aspx?displaylang=en&FamilyID=b3b02475-150c-41fa-844a-c10a517040f4" target="_blank">HERE</a>. Thank goodness I setup a highly redundant load balanced farm of front end servers as the first server updated immediately had issues with the front-end services starting. Wow, updates strike again (other stories forthcoming soon, I promise).

<!--more-->

So I did a quick lookup on WTF was going on and apparently I failed to follow the rules. I guess I needed to roll the update found at the same link, OCS2009-DBUpgrade.msi. Oh and run this in an admin command line with the optiont POOLNAME=<your stupid pool name>. And, whoops, you cannot run this on a front end server as it is a database update and requires sql components to be installed. Damn. If you try to run it from one of your database servers you get errors that the OCS admin tools are needed. How totally intuitive, eh? I know we all manage our front end servers from the back-end database clusters they use (note the heavy sarcasm here). So install your admin tools on your (hopefully clustered) database server, run this update in a command line window with the poolname option, then run our beloved serverupdateinstaller.exe on your front end servers (or if you already did try to update your FE&#8217;s then just start the front end service after the back end update).

The next time I hear a Mac/Linux head blather on about how awful MS products are, unless they have ever really done any MS admin work, I&#8217;m just going to back hand them across the face. And then I&#8217;ll probably agree with them but from an entirely different viewpoint. And then I&#8217;ll buy them a beer so they don&#8217;t beat me up.