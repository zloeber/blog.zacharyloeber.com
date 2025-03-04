---
title: 'Exchange: Automatically Generating Configuration Scripts'
author: Zachary Loeber
type: post
date: 2012-09-29T17:33:20+00:00
excerpt: "I've started a side project which aims to automate Exchange configurations for server role prerequisite procedures, co-existence configuration, DAG/CAS configuration, and other general reminders and processes."
url: /blog/2012/09/29/exchange-automatically-generating-configuration-scripts/
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - IIS
  - Microsoft
  - Powershell
  - System Administration

---
I&#8217;ve started a side project which is born from personally having to redo many aspects of an Exchange migration over and over again. Most of this, I believe, can be automated. Some aspects of this process include exchange server role prerequisite procedures, co-existence configuration, DAG/CAS configuration, and other general reminders and processes.

<!--more-->

Where To Download and find future updates: [Microsoft Script Gallery][1]

**HOW TO USE:**

Pretty simple acctually. Enter in information about every server in your exchange environment. There is no sanity checking on names and such so try to be as concise as possible. The URLs should be in the form of server.domain.com without any protocol or path.

The design model I&#8217;m basing the script output on assumes that you want to have forms based authentication both internally and externally and that externally facing CAS servers are behind a reverse proxy doing basic authentication. So to get full use of this script on a 2 node cas array you would have a total of 5 IP addresses defined but only 4 entries in your server list. 2 for each server and one for the NLB internal IP (which is an included field when you select the NLB option). If you are doing all-in-one servers just define the same server name with multiple roles. If you have a larger environment you can save the config into a csv file for later use or general documentation as well.

**STATUS**

Here is the current status of this personal project. I welcome all input whole heartedly. And until I say otherwise I&#8217;m not even endorsing my own script as feasible for production worthy utilization. So obviously don&#8217;t just wantonly run the scripts that get generated. (In fact I know I&#8217;m missing a few things like fixing the OAB virtual directory permission issue). At the moment only 2008 R2 with Exchange 2010 HUB/CAS/Database roles are functioning. I&#8217;ve placeholders for the other stuff, it just is not done yet.

**CURRENT CAPABILITY**

**Exchange 2003**

_NA_

**Exchange 2007**

_NA_

**Exchange 2010** 

  * Save/Restore input to/from csv
  * Generate general prerequisites for windows 2008 R2
  * Generate general HUB/CAS server prerequisites
  * Generate general Database/Mailbox server prerequisite
  * Generate base CAS configuration for internal/external configurations 
      * Optionally configure ssl and path redirection
      * Optionally assume external facing sites are behind reverse proxy
      * SSL Offload code not generated (yet!)
  * Generate NLB configurations

**Exchange 2012**

_NA_

**DESIRED CAPABILITY:**

  * Provide prerequisite information for all versions of exchange (2007 and forward) for migration scenarios
  * Perform sanity checks on input (have a bit of that but not being used yet)
  * Generate scripts for configuring Hub/CAS servers internal and external configuration for co-existence scenarios.
  * Generate scripts for configuring Hub/CAS servers internal and external configuration for allowing forms based auth both internally and externally (assuming enough IPs have been provisioned of course)
  * Generate scripts for configuring CAS Arrays per site
  * Generate DAG scripts
  * Generate local route scripts for multi-interface scenarios
  * Do all of the above for both Exchange 2010 and 2013
  * Include specific co-existance guidance for 2003/2007
  * Generate prerequisites for Windows 2012
  * Provide the meaning of life, the universe, and everything.

**VERSION INFO:**

_<span style="text-decoration: underline;">Version 0.1 &#8211; 09/29/2012</span>_

  * Running out of time on my primalforms powershell studio demo so I quickly updated the form to add an options section
  * Greatly improved script output with regions and formatting changes
  * Added NLB Configuration
  * Added internal/external virtual directory matched sets detection (for future use)
  * Numerous other fixes

_<span style="text-decoration: underline;">Version .02 &#8211; 09/25/2012</span>_

  * Rearanged the form a bit
  * Added in a beta of exporting internal/external CAS configuration scripts
  * Vastly improved the pre-config script export
  * Update the catagorization to include OS and Exchange versions (for future fun)

_<span style="text-decoration: underline;">Version .01 &#8211; 09/22/2012</span>_

  * Fixed tabbing order
  * Added subnet (for future route add directions)
  * Made prerequisite generation to be per server
  * Fixed server sorting code
  * Added database server prerequisite generation
  * Added all versions of exchange (including 2013) with appropriate enabling and disabling of form input per role/version
  * Made massive improvements on output of prerequisites (including general recommendations and segmentation)

_<span style="text-decoration: underline;">Version .001 &#8211; Initial cruddy release</span>_

  * This release is SO alpha that all it does at this point is generate some basic prerequisites for HUB/CAS servers. There is more to come (time permitting). The more encouragement I get from responses to this super alpha release, the more I&#8217;m going to be inclined to further develop it. Otherwise, I&#8217;m just putting this out there as an idea which I&#8217;d like to further develop as time permits.

[<img class="alignnone size-medium wp-image-616" title="configurator" src="/wp-content/uploads/2012/09/configurator.jpg?resize=300%2C135" alt="Exchange 2010 Configurator" width="300" height="135" srcset="/wp-content/uploads/2012/09/configurator.jpg?resize=300%2C135 300w, wp-content/uploads/2012/09/configurator.jpg?w=740 740w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]

 [1]: http://gallery.technet.microsoft.com/exchange/Exchange-Quick-Configurator-68f717c5
 [2]: wp-content/uploads/2012/09/configurator.jpg