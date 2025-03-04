---
title: Excel and HTML Asset Reports With Powershell
author: Zachary Loeber
type: post
date: 2013-09-08T05:07:29+00:00
url: /blog/2013/09/08/excel-and-html-asset-reports-with-powershell/
categories:
  - Active Directory
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - 2008 R2
  - Active Directory
  - Microsoft
  - Monitoring
  - network administration
  - Powershell
  - Sysadmin
  - System Administration
  - Windows

---
This set of powershell functions collates and generates reports upon system information it gathers. Information gathered includes hardware health, system information, networking information and much much more. Multiple types of html reports can be generated and all data can be exported directly to an excel workbook, saved as individual reports, and emailed.

<!--more-->

The reports offer a high level of data customization and currently come with two example data sets. One for daily system reports which contains less overall information. And another, far more inclusive, system documentation report. The html output can be highly customized as well. Currently there is a dynamic grid html report based on responsive design templates as well as a less glitzy email capable html format. The report data can also be returned directly to an excel workbook where several sheets will automatically populate and be formatted for easier reading and further manipulating.

### Features

Generate system asset reports in multiple formats including:

  * Report Containers/Types 
      * Troubleshooting &#8211; A small subset of system information meant for daily reports
      * Documentation &#8211; A large amount of system information meant for environment analysis and documentation
  * HTML Templates 
      * DynamicGrid &#8211; A heavily modified CSS layout
      * EmailFriendly &#8211; A basic layout
  * Saved Report Layout 
      * Individual &#8211; Each asset saves as its own file
      * One big report &#8211; All assets are included in one big report
  * Saved Report File Format 
      * HTML
      * PDF **\*New\***
  * Email Reports (HTML only)

### Report Data

Sections included in the system asset report include:

  * System Information 
      * Summary 
          * OS
          * CPUs
          * Memory Usage
          * Server Models
          * Virtualization detection
      * Extended Summary 
          * NTP information
          * Product key
          * Registration Info
      * Dell Warranty Information
      * Disk Report
      * Environmental Variables **\*New\***
      * Memory Banks
      * Top processes by memory utilization
      * Startup Commands **\*New\***
      * Stopped services (which are set to start automatically)
      * Services starting with non-standard credentials
  * Event Log Information 
      * Event Log Settings
      * Event log errors/warnings/security failures for past number of hours
  * Networking Information 
      * Network Adapters
      * Local Hosts File Contents **\*New\***
      * Local DNS Cache **\*New\***
      * Route Table
  * Software Audit 
      * Installed Hotfixes
      * Installed Applications
  * File/Print 
      * Shares
      * Share session information
      * Printers
      * VSS Volume Usage **\*New\***
      * VSS Writers **\*New\***
      * WSUS settings
      * Installed printers
  * Local Security 
      * Local Group Membership
      * Applied GPOs
  * HP hardware health 
      * HP general hardware health
      * HP ethernet team health
      * HP ethernet health
      * HP fan health
      * HP HBA health
      * HP power supply health
      * HP temperature sensor readings

### Version Info

**1.1.0 &#8211; 09/22/2013**

  * Added option to save results to PDF with the help of a nifty library from https://pdfgenerator.codeplex.com/
  * Added a few more resport sections for the system report: 
      * Startup programs
      * Local host file entries
      * Cached DNS entries (and type)
      * Shadow volumes
      * VSS Writer status
  * Added the ability to add different section types, specifically section headers
  * Added ability to completely skip over previously mentioned section headers&#8230;
  * Added ability to add section comments which show up directly below the section table titles and just above the section table data
  * Added ability to save reports as PDF files
  * Modified grid html layout to be slightly more condensed.
  * Added ThrottleLimit and Timeout to main function (applied only to multi-runspace called functions)
  * 

### Notes

I suppose I&#8217;ll upgrade this from beta status to non-beta, or whatever comes next. I&#8217;m mostly happy with the report layout and formatting for the DynamicGrid template. I&#8217;ve also breached new ground with a whole new set of data results for inclusion in the asset reports (with a recently released set of functions for returning the results of a remotely run command via alternate credentials). The EmailFriendly format still needs some attention but should serve its purpose.

While the reports are pretty, I think that the real value to professionals is in the excel export this script can automatically generate. You can determine a whole lot from the information this script gathers. You can quickly isolate nic cards in promiscuous mode, find servers using strange license keys, and more.

### Screenshots

One of the excel sheets

<img alt="" src="http:///gallery.technet.microsoft.com/site/view/file/95459/1/excel-1.jpg?resize=586%2C197" width="586" height="197" data-recalc-dims="1" />

The HP hardware health section of an html report:

<img alt="" src="http:///gallery.technet.microsoft.com/site/view/file/95460/1/HP_Health.jpg?resize=586%2C240" width="586" height="240" data-recalc-dims="1" />

A summary section of an html report:

<img alt="" src="http://gallery.technet.microsoft.com/site/view/file/95461/1/Summary_Section.jpg?resize=586%2C400" width="586" height="400" data-recalc-dims="1" />

A disk usage html report section:

<img alt="" src="http:///gallery.technet.microsoft.com/site/view/file/95463/1/Disk-Usage.jpg?resize=586%2C109" width="586" height="109" data-recalc-dims="1" />

### Downloads

[Download the script from the technet gallery (more frequently updated)][1]

 [1]: http://gallery.technet.microsoft.com/Excel-and-HTML-Asset-0ffbf569