---
title: 'VMware: VMware Report Generation GUI'
author: Zachary Loeber
type: post
date: 2013-02-17T17:11:52+00:00
excerpt: This GUI is meant to configure regular vmware report generation. You are able to select reporting scoped to the whole farm down to individual hosts. Reports can be emailed or saved and be generated based on custom thresholds.
url: /blog/2013/02/17/vmware-vmware-report-generation-gui/
categories:
  - Networking
  - Powershell
  - System Administration
  - Virtualization
  - VMware
tags:
  - network administration
  - Powershell
  - Scripting
  - System Administration
  - virtualization
  - vmware

---
Its been a while since I posted something new. This GUI is meant to configure regular vmware report generation. You are able to select reporting scoped to the whole farm down to individual hosts. Reports can be emailed or saved and be generated based on custom thresholds.

<!--more-->

<h2 style="margin: 10pt 0in 0pt;">
  <span style="font-family: Cambria;">Version History<br /> </span>
</h2>

<p class="MsoNormal" style="line-height: normal; margin: 0in 0in 0pt; mso-layout-grid-align: none;">
  <span style="font-family: 'Microsoft Sans Serif','sans-serif'; font-size: 8.5pt;">0.0.1 &#8211; 02/12/2013<br /> &#8211; First release<br /> 0.0.2 &#8211; 03/29/2013<br /> &#8211; Removed clear text password from config file<br /> &#8211; Allowed for alternate credentials for wmi calls<br /> &#8211; Many GUI updates and fixes.<br /> </span>
</p>

<h2 style="margin: 10pt 0in 0pt;">
  History
</h2>

The short history of this script stems from two side projects I had started several months ago. One was to better template out an option saving gui/script/xml project for future script releases. Another was for redoing some of the vmware reporting scripts I&#8217;ve used in the past. Currently the generated report is in a pretty ugly format (for me at least) but it is serviceable for the data currently gathered. In the future I aim to change the template to allow for stylized reports as well as allow a rudimentary automatic scheduling of the script from within the GUI.

## <span style="font-family: Cambria;">Options</span>

<p class="MsoNormal" style="line-height: normal; margin: 0in 0in 0pt; mso-layout-grid-align: none;">
  <span style="font-family: 'Microsoft Sans Serif','sans-serif'; font-size: 8.5pt;">There are several options for those interested in monitoring their environment. Some options include;</span>
</p>

<h3 style="margin: 10pt 0in 0pt;">
  <span style="font-family: Cambria;">General Options</span>
</h3>

  * <span style="font-family: 'Microsoft Sans Serif','sans-serif'; font-size: 8.5pt;">Generating reports if thresholds are surpassed</span>

<h3 style="margin: 10pt 0in 0pt;">
  <span style="font-family: Cambria;">Virtual Center</span>
</h3>

  * VC event errors (with threshold in # of days)
  * VMs created/cloned/deleted
  * VC windows server errors/warnings (with threshold in # of days)
  * VC windows server service status

<h3 style="margin: 10pt 0in 0pt;">
  <span style="font-family: Cambria;">ESX/vSphere Hosts</span>
</h3>

  * Hosts not responding
  * Hosts in maintenance
  * Host datastore utilization (with % free utilization threshold)

<h3 style="margin: 10pt 0in 0pt;">
  <span style="font-family: Cambria;">Virtual Machines</span>
</h3>

  * VM snapshots (with threshold in # of days)
  * VMs with thin provisioned disks
  * VMs with no vmware tools
  * VMs with connected CD drives
  * VMs with connected floppy drives

<h2 style="margin: 10pt 0in 0pt;">
  Usage
</h2>

The GUI is used to perform an initial test connection to the server and to save options. Once connected to the server you can select more granular scoped reports based on the datacenter, cluster, and host if desired. Currently you need to report on the whole farm to get virtual center reporting options. Once the configuration is saved another script, VMware-Report.ps1 can be used to schedule the job (it will automatically load the saved xml config file and run without any interface).

**Note:** Alternately you can just modify the Globals.ps1 script variables and not use either the save file or the gui and the VMware-Report.ps1 script will run on that information alone.

**Another Note:** If you want to generate several kinds of reports at different times simply copy all three ps1 files to another directory and create a new config file with the GUI and use scheduled tasks to run the script.

<h2 class="MsoNormal" style="line-height: normal; margin: 0in 0in 0pt; mso-layout-grid-align: none;">
  Screenshots
</h2>

<p class="MsoNormal" style="line-height: normal; margin: 0in 0in 0pt; mso-layout-grid-align: none;">
  <span style="font-family: 'Microsoft Sans Serif','sans-serif'; font-size: 8.5pt;"><a href="/wp-content/uploads/2013/02/vmware-report-gui-1.jpg"><img class="aligncenter size-full wp-image-730" alt="vmware-report-gui-1" src="/wp-content/uploads/2013/02/vmware-report-gui-1.jpg?resize=462%2C500" width="462" height="500" srcset="/wp-content/uploads/2013/02/vmware-report-gui-1.jpg?w=462 462w, /wp-content/uploads/2013/02/vmware-report-gui-1.jpg?resize=277%2C300 277w" sizes="(max-width: 462px) 100vw, 462px" data-recalc-dims="1" /></a> <a href="/wp-content/uploads/2013/02/vmware-report-gui-2.jpg"><img class="aligncenter size-full wp-image-731" alt="vmware-report-gui-2" src="/wp-content/uploads/2013/02/vmware-report-gui-2.jpg?resize=464%2C505" width="464" height="505" srcset="/wp-content/uploads/2013/02/vmware-report-gui-2.jpg?w=464 464w, wp-content/uploads/2013/02/vmware-report-gui-2.jpg?resize=275%2C300 275w" sizes="(max-width: 464px) 100vw, 464px" data-recalc-dims="1" /></a> <a href="/wp-content/uploads/2013/02/vmware-report-gui-3.jpg"><img class="aligncenter size-full wp-image-732" alt="vmware-report-gui-3" src="/wp-content/uploads/2013/02/vmware-report-gui-3.jpg?resize=466%2C505" width="466" height="505" srcset="/wp-content/uploads/2013/02/vmware-report-gui-3.jpg?w=466 466w, wp-content/uploads/2013/02/vmware-report-gui-3.jpg?resize=276%2C300 276w" sizes="(max-width: 466px) 100vw, 466px" data-recalc-dims="1" /></a> <a href="/wp-content/uploads/2013/02/vmware-report-gui-4.jpg"><img class="aligncenter size-full wp-image-733" alt="vmware-report-gui-4" src="/wp-content/uploads/2013/02/vmware-report-gui-4.jpg?resize=586%2C701" width="586" height="701" srcset="/wp-content/uploads/2013/02/vmware-report-gui-4.jpg?w=652 652w, wp-content/uploads/2013/02/vmware-report-gui-4.jpg?resize=250%2C300 250w" sizes="(max-width: 586px) 100vw, 586px" data-recalc-dims="1" /></a><br /> </span>
</p>

Download: [VMware-Report-GUI][1]

[At VMware Community Site][2]

[At Microsoft Script Gallery][3]

 [1]: /wp-content/uploads/2013/02/VMware-Report-GUI.zip
 [2]: http://communities.vmware.com/docs/DOC-21801#cf "VMware Report GUI at VMware Community"
 [3]: /2013/01/15/exchange-co-existence-client-access-preparation-report/ "VMware Report GUI at Microsoft Script Gallery"