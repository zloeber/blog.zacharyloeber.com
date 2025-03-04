---
title: Active Directory Audit Report With Powershell
author: Zachary Loeber
type: post
date: 2013-10-18T15:13:11+00:00
url: /blog/2013/10/18/active-directory-audit-report-with-powershell/
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Lync
  - Microsoft
  - Office Communicator Server
  - Powershell
  - System Administration

---
Not too long ago I wrote a quick post on how easy it is to gather information from AD. As a case in point example I provided a script to gather all the disabled user accounts which are still assigned Lync IDs. In this script I take it one step further and provide a full blown Active Directory reporting script which can be produced with any non-privileged domain user account.

<!--more-->

### Features

<span style="line-height: 1.6;">To create the output I repurposed my server asset reporting script. This means several output methods are baked right in.</span>

  * Report Containers/Types

  * Documentation – Currently the only format for this type of report. This returns all data gathered in the report.
  * HTML Templates 
      * DynamicGrid – A heavily modified CSS layout
      * EmailFriendly – A basic layout
  * Saved Report Layout 
      * <span style="text-decoration: line-through;">Individual – Each asset saves as its own file </span>
      * One big report – Only a single report will be generated no matter which option you choose.
  * Saved Report File Format 
      * HTML
      * PDF
  * Email Reports (HTML only)
  * Export all data to individual worksheets within Excel

Aside from the report, additionally three diagrams will be created which this script is run. One for domain trusts, another for site replication connections, and a third for site adjacencies. By default the diagram source text file and a png file will get created in the directory which you run the script.

To actually generate the diagrams you will need graphviz’s dot.exe executable which can be downloaded and installed [here][1]. Or [here is a portable version][2] of the application you can try utilizing. All you need is for the dot.exe file to work correctly to generate your diagram. You may have to modify this script to use the appropriate path to the executable if you use the portable version of graphviz.

(If you don&#8217;t care about the diagrams either comment out the code or ignore the errors as it tries to run dot.exe)

### Report Data

I’ve included only items which can be gathered from Active Directory with a regular user account and without any special AD modules. This is what has been added thus far:

  * Forest Information 
      * Forest Summary 
          * Name/<span style="line-height: 1.6;">Functional Level</span>
          * <span style="line-height: 1.6;">Domain/Site/</span><span style="line-height: 1.6;">DC/GC/Exchange/Lync/Pool counts</span>
      * <span style="line-height: 1.6;">Forest Features</span> 
          * Tombstone Lifetime
          * <span style="line-height: 1.6;">Recycle Bin Enabled</span>
          * <span style="line-height: 1.6;">Lync AD Container</span>
      * <span style="line-height: 1.6;">Exchange Servers</span> 
          * <span style="line-height: 1.6;">Organization/Administrative Group/Name/Roles/Site</span>
          * <span style="line-height: 1.6;">Serial/Product ID</span>
      * <span style="line-height: 1.6;">Lync</span> 
          * <span style="line-height: 1.6;">Element (Server/Pool)</span>
          * <span style="line-height: 1.6;">Type (Internal/Edge/Backend/Pool)</span>
          * <span style="line-height: 1.6;">Name/FQDN</span>
      * <span style="line-height: 1.6;">Site Information</span> 
          * <span style="line-height: 1.6;">Summary</span> 
              * <span style="line-height: 1.6;">Site Name/Location/Domains/DCs/Subnets</span>
          * <span style="line-height: 1.6;">Details</span> 
              * <span style="line-height: 1.6;">Site Name/Options/ISTG/Links/Bridgeheads/Adjacencies</span>
          * <span style="line-height: 1.6;">Subnets</span> 
              * <span style="line-height: 1.6;">Subnet/Site Name/Location</span>
          * <span style="line-height: 1.6;">Site Connections</span> 
              * <span style="line-height: 1.6;">Enabled/Options/From/To</span>
      * <span style="line-height: 1.6;">Domain Information</span> 
          * <span style="line-height: 1.6;">Domains</span> 
              * <span style="line-height: 1.6;">Name/NetBIOS/Functional Level/Forest Root/Assigned FSMO Roles</span>
          * <span style="line-height: 1.6;">Domain Password Policies</span> 
              * <span style="line-height: 1.6;">Name/NetBIOS/Lockout Threshold/Pass History Length/Max Pass Age/Min Pass Age/Min Pass Length</span>
          * <span style="line-height: 1.6;">Domain Controllers</span> 
              * <span style="line-height: 1.6;">Domain/Site/Name/OS/Time/IP/GC/FSMO Roles</span>
          * <span style="line-height: 1.6;">Domain Trusts</span> 
              * <span style="line-height: 1.6;">Domain/Trusted Domain/Direction/Attributes/Trust Type/Created/Modified</span>
          * <span style="line-height: 1.6;">Domain DFS Shares</span> 
              * <span style="line-height: 1.6;">Domain/Name/DN/Remote Server</span>

### Screenshots

Here are some screenshots of the reports and diagrams which can be created:

[<img style="margin: 5px; display: inline; background-image: none;" title="DCs-Screenshot" alt="DCs-Screenshot" src="/wp-content/uploads/2013/10/DCs-Screenshot_thumb.jpg?resize=555%2C257" width="555" height="257" border="0" data-recalc-dims="1" />][3]

[<img style="margin: 5px; display: inline; background-image: none;" title="domains-screenshot" alt="domains-screenshot" src="/wp-content/uploads/2013/10/domains-screenshot_thumb.jpg?resize=557%2C50" width="557" height="50" border="0" data-recalc-dims="1" />][4]

[<img style="margin: 5px; display: inline; background-image: none;" title="ForestSummary-screenshot" alt="ForestSummary-screenshot" src="/wp-content/uploads/2013/10/ForestSummary-screenshot_thumb.jpg?resize=428%2C154" width="428" height="154" border="0" data-recalc-dims="1" />][5]

[<img style="margin: 5px; display: inline; background-image: none;" title="Lync-sreenshot" alt="Lync-sreenshot" src="/wp-content/uploads/2013/10/Lync-sreenshot_thumb.jpg?resize=268%2C215" width="268" height="215" border="0" data-recalc-dims="1" />][6]

[<img style="margin: 5px; display: inline; background-image: none;" title="SiteConnections-screenshot" alt="SiteConnections-screenshot" src="/wp-content/uploads/2013/10/SiteConnections-screenshot_thumb.jpg?resize=267%2C164" width="267" height="164" border="0" data-recalc-dims="1" />][7]

[<img style="margin: 5px; display: inline; background-image: none;" title="SiteSubnets-screenshot" alt="SiteSubnets-screenshot" src="/wp-content/uploads/2013/10/SiteSubnets-screenshot_thumb.jpg?resize=261%2C152" width="261" height="152" border="0" data-recalc-dims="1" />][8]

[<img style="margin: 5px; display: inline; background-image: none;" title="Trusts-screenshot" alt="Trusts-screenshot" src="/wp-content/uploads/2013/10/Trusts-screenshot_thumb.jpg?resize=359%2C106" width="359" height="106" border="0" data-recalc-dims="1" />][9]

[<img style="margin: 5px; display: inline; background-image: none;" title="trusts-screenshot2" alt="trusts-screenshot2" src="/wp-content/uploads/2013/10/trusts-screenshot2_thumb.jpg?resize=410%2C102" width="410" height="102" border="0" data-recalc-dims="1" />][10]

### Downloads

[You can download the script from the technet galleries.][11]

 [1]: http://graphviz.org/
 [2]: https://code.google.com/p/graph-viz-portable/downloads/list
 [3]: wp-content/uploads/2013/10/DCs-Screenshot.jpg
 [4]: wp-content/uploads/2013/10/domains-screenshot.jpg
 [5]: wp-content/uploads/2013/10/ForestSummary-screenshot.jpg
 [6]: wp-content/uploads/2013/10/Lync-sreenshot.jpg
 [7]: wp-content/uploads/2013/10/SiteConnections-screenshot.jpg
 [8]: /wp-content/uploads/2013/10/SiteSubnets-screenshot.jpg
 [9]: wp-content/uploads/2013/10/Trusts-screenshot.jpg
 [10]: /wp-content/uploads/2013/10/trusts-screenshot2.jpg
 [11]: http://gallery.technet.microsoft.com/Active-Directory-Audit-7754a877