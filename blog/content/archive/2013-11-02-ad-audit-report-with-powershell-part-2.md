---
title: 'AD Audit Report With Powershell: Part 2'
author: Zachary Loeber
type: post
date: 2013-11-02T17:41:25+00:00
excerpt: "I've updated my AD auditing report. The forest level report now includes AD integrated zones, GPOs, and fixed code to conform to strict v2 Powershell. I've also included a new domain level report! This report provides some user/group stats, all privileged group membership, and more."
url: /blog/2013/11/02/ad-audit-report-with-powershell-part-2/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - Lync
  - Microsoft
  - Office Communicator Server
  - Powershell
  - System Administration

---
I&#8217;ve updated my AD auditing report. The forest level report now includes AD integrated zones, GPOs, and fixed code to conform to strict v2 Powershell. I&#8217;ve also included a new domain level report! This report provides some user/group stats, all privileged group membership, and more.

<!--more-->

### Reporting Features

I’ve been gradually updating my server asset reporting script as part of this project. This means several output methods are baked right in from my earlier efforts and a few new ones have been added which are specific to the AD auditing scropt.

#### Report Containers/Types

Each report hash structure acts as a container for all the sections and report types available. The container can have any number of report type definitions. For the AD reports I define two structures. One for forest level reporting and another for domain level reporting. These each have their own report types which suit different needs.

_<span style="text-decoration: underline;">$ADForestReport</span>_

This is for the forest level reporting. The report types to choose from are:

FullDocumentation – This is suitable for the HTML/PDF reports. This is the default report type.

ExcelExport – This is suitable for excel exports. Even though you can use the –ExportToExcel switch on any report type, this report has multiline output elements which require specially formatted html elements that do not lend themselves to excel workbooks. This is all the data in the FullDocumentation report but without the special HTML formatting. If you use this report type then you will want to suppress the HTML output (basically use the following flags: -ExportToExcel –NoReport)

<span style="text-decoration: underline;"><em>$ADDomainReport</em></span>

This is for the domain level reporting. There is only one type of report type to choose (so you don’t really have to even supply this in the function as it will default to the first reporttype).

FullDocumentation – This is suitable for HTML/PDF reports as well as excel exports.

#### HTML Templates

These HTML templates have not changed.

DynamicGrid – A heavily modified CSS layout. This is the default HTML output format.

EmailFriendly – A basic layout suitable for emailed embedded reports.

#### Saved Report Layout

There are a few different ways  PDF/HTMLs can be output. This AD information is mostly suited to individual reports.

Individual – Each asset saves as its own file

One big report – Only a single report will be generated.

### Report Output

HTML – See the HTML templates for a few different options on this one.

PDF – This converts the HTML format to PDF files using a third-party open source DLL (so you still have to choose HTML templates when exporting to PDF).

Email &#8211; HTML embedded email.

Excel Export &#8211; Export all results to individual worksheets within Excel. Each section generates its own workbook.

### Optional Report Output

The $ADDomainReport includes a few export options which can be set by global variables. The variables are:

$EXPORTTOCSV_ALLUSERS – Create a CSV file with all users of the domain.

$EXPORTTOCSV_PRIVUSERS – Create a separate CSV file with all privileged users of the domain.

This may slow down the report but the output can be quite interesting. Exporting all the users in each domain also includes appended output from a special function I wrote to pull out all useraccountcontrol information for a user account and another special function I wrote to normalize attribute information. This is useful when some users are exchange/lync enabled and some are not. Exchange/Lync enabling a user adds extra attributes which otherwise are not there. This normalization accounts for these attributes and assigns them a null value if unavailable.

#### Graphs

Aside from the report, additionally three diagrams can be created which this script is run against the $ADForestReport container:

  * Domain trusts
  * Site replication connections
  * Site adjacencies

You can choose to create a diagram source text file and/or a png file with the following global variables:

$AD_CreateDiagramSourceFiles
  
$AD_CreateDiagrams

To actually generate the diagrams you will need graphviz’s dot.exe executable which can be downloaded and installed [here][1]. Or [here is a portable version][2] of the application you can try utilizing. All you need is for the dot.exe file to work correctly to generate your diagram. You may have to modify this script to use the appropriate path to the executable if you use the portable version of graphviz.

You can specify the path of dot.exe with the following global variable:

$Graphviz_Path

### Report Data

I’ve included only items which can be gathered from Active Directory with a regular user account and without any special AD modules. Each report contains different information worth checking out:

#### $ADForestReport

This contains forest wide information.

##### **_Forest Information_**

<span style="text-decoration: underline;">Forest Summary</span>

  * Name
  * Functional Level
  * Domain Count
  * Site Count
  * DC Count
  * GC Count
  * Exchange Count
  * Lync/Pool counts

<span style="text-decoration: underline;">Forest Features</span>

  * Tombstone Lifetime
  * Recycle Bin Enabled
  * Lync AD Container

<span style="text-decoration: underline;">Exchange Servers</span>

  * Organization
  * Administrative Group
  * Name
  * Roles
  * Site
  * <span style="line-height: 1.6;">Serial/Product ID</span>

<span style="text-decoration: underline;">Lync/OCS</span>

  * Element (Server/Pool)
  * Type (Internal/Edge/Backend/Pool)
  * Name/FQDN

##### _**Site Information**_

<span style="text-decoration: underline;">Summary</span>

  * Site Name
  * Location
  * Domains
  * DCs
  * Subnets

<span style="text-decoration: underline;">Details</span>

  * Site Name
  * Options
  * ISTG
  * Links
  * Bridgeheads
  * Adjacencies

<span style="text-decoration: underline;">Subnets</span>

  * Subnet
  * Site Name
  * Location

<span style="text-decoration: underline;">Site Connections</span>

  * Enabled
  * Options
  * From
  * To

##### _**Domain Information**_

<span style="text-decoration: underline;">Forest Domains</span>

  * Name
  * NetBIOS
  * Functional Level
  * Forest Root
  * Assigned FSMO Roles

<span style="text-decoration: underline;">Domain Password Policies</span>

  * Domain Name
  * NetBIOS Name
  * Lockout Threshold
  * Pass History Length
  * Max Pass Age
  * Min Pass Age
  * Min Pass Length

<span style="text-decoration: underline;">Domain Controllers</span>

  * Domain
  * Site
  * Server Name
  * OS
  * Time
  * IP
  * GC
  * FSMO Roles

<span style="text-decoration: underline;">Domain Trusts</span>

  * Domain
  * Trusted Domain
  * Trust Direction
  * Attributes
  * Trust Type
  * Created
  * Modified

<span style="text-decoration: underline;">DFS Shares</span>

  * Domain
  * Name
  * DN
  * Remote Server

<span style="text-decoration: underline;">DFSR Shares</span>

  * Domain
  * Name
  * Content (shares)
  * Remote Servers

<span style="text-decoration: underline;">Integrated DNS Zones</span>

  * Zone Name
  * Domain
  * Partition
  * Record Count
  * Created
  * Changed

<span style="text-decoration: underline;">GPOs</span>

  * Domain
  * Name
  * Created
  * Changed

#### $ADDomainReport

This contains per-domain account and group information which is largely focused on account security and discovery.

<span style="text-decoration: underline;">Account Statistics (count) 1</span>

  * Total User Accounts
  * Enabled
  * Disabled
  * Locked
  * Password Does Not Expire
  * Password Must Change

<span style="text-decoration: underline;">Account Statistics (count) 2</span>

  * Password Not Required
  * Dial-in Enabled
  * Control Access With NPS
  * Unconstrained Delegation
  * Not Trusted For Delegation
  * No Pre-Auth Required

<span style="text-decoration: underline;">Group Statistics</span>

  * Total Groups
  * Built-in
  * Universal Security
  * Universal Distribution
  * Global Security
  * Global Distribution
  * Domain Local Security
  * Domain Local Distribution

<span style="text-decoration: underline;">Privileged Group Statistics</span>

  * Default Priv Group Name
  * Current Group Name (if it were changed)
  * Member Count

<span style="text-decoration: underline;">Privileged Group Membership for the following groups</span>

  * Enterprise Admins
  * Schema Admins
  * Domain Admins
  * Administrators
  * Cert Publishers
  * Account Operators
  * Server Operators
  * Backup Operators
  * Print Operators

<span style="text-decoration: underline;">Account information for the prior sections:</span>

  * Logon ID
  * Name
  * Password Age (Days)
  * Last Logon Date
  * Password Does Not Expire
  * Password Reversable
  * Password Not Required

### Screenshots

[<img class="aligncenter size-medium wp-image-994" alt="Trusts-screenshot.jpg" src="/wp-content/uploads/2013/10/Trusts-screenshot.jpg?resize=300%2C86" width="300" height="86" srcset="/wp-content/uploads/2013/10/Trusts-screenshot.jpg?resize=300%2C86 300w, wp-content/uploads/2013/10/Trusts-screenshot.jpg?w=622 622w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3] [<img class="aligncenter size-medium wp-image-996" alt="trusts-screenshot2.jpg" src="/wp-content/uploads/2013/10/trusts-screenshot2.jpg?resize=300%2C72" width="300" height="72" srcset="/wp-content/uploads/2013/10/trusts-screenshot2.jpg?resize=300%2C72 300w, /wp-content/uploads/2013/10/trusts-screenshot2.jpg?w=961 961w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][4] [<img class="aligncenter size-medium wp-image-988" alt="Lync-sreenshot.jpg" src="/wp-content/uploads/2013/10/Lync-sreenshot.jpg?resize=300%2C240" width="300" height="240" srcset="/wp-content/uploads/2013/10/Lync-sreenshot.jpg?resize=300%2C240 300w, wp-content/uploads/2013/10/Lync-sreenshot.jpg?w=413 413w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][5] [<img class="aligncenter size-medium wp-image-992" alt="SiteSubnets-screenshot.jpg" src="/wp-content/uploads/2013/10/SiteSubnets-screenshot.jpg?resize=300%2C172" width="300" height="172" srcset="/wp-content/uploads/2013/10/SiteSubnets-screenshot.jpg?resize=300%2C172 300w, /wp-content/uploads/2013/10/SiteSubnets-screenshot.jpg?w=351 351w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][6] [<img class="aligncenter size-medium wp-image-990" alt="SiteConnections-screenshot.jpg" src="/wp-content/uploads/2013/10/SiteConnections-screenshot.jpg?resize=300%2C182" width="300" height="182" srcset="/wp-content/uploads/2013/10/SiteConnections-screenshot.jpg?resize=300%2C182 300w, wp-content/uploads/2013/10/SiteConnections-screenshot.jpg?w=408 408w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][7] [<img class="aligncenter size-medium wp-image-986" alt="ForestSummary-screenshot.jpg" src="/wp-content/uploads/2013/10/ForestSummary-screenshot.jpg?resize=300%2C106" width="300" height="106" srcset="/wp-content/uploads/2013/10/ForestSummary-screenshot.jpg?resize=300%2C106 300w, wp-content/uploads/2013/10/ForestSummary-screenshot.jpg?w=736 736w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][8] [<img class="aligncenter size-medium wp-image-983" alt="DCs-Screenshot_thumb.jpg" src="/wp-content/uploads/2013/10/DCs-Screenshot_thumb.jpg?resize=300%2C138" width="300" height="138" srcset="/wp-content/uploads/2013/10/DCs-Screenshot_thumb.jpg?resize=300%2C138 300w, /wp-content/uploads/2013/10/DCs-Screenshot_thumb.jpg?w=555 555w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][9]

Here are some reports from the Domain level report&#8230;

[<img class="aligncenter size-medium wp-image-1012" alt="Domain-Stats-Screenshot" src="/wp-content/uploads/2013/11/Domain-Stats-Screenshot.jpg?resize=300%2C128" width="300" height="128" srcset="/wp-content/uploads/2013/11/Domain-Stats-Screenshot.jpg?resize=300%2C128 300w, /wp-content/uploads/2013/11/Domain-Stats-Screenshot.jpg?w=813 813w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][10] [<img class="aligncenter size-medium wp-image-1013" alt="Domain-Groups-Screenshot" src="/wp-content/uploads/2013/11/Domain-Groups-Screenshot.jpg?resize=300%2C89" width="300" height="89" srcset="/wp-content/uploads/2013/11/Domain-Groups-Screenshot.jpg?resize=300%2C89 300w, wp-content/uploads/2013/11/Domain-Groups-Screenshot.jpg?w=658 658w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][11] [<img class="aligncenter size-medium wp-image-1014" alt="Domain-PrivGroupMembership-Screenshot" src="/wp-content/uploads/2013/11/Domain-PrivGroupMembership-Screenshot.jpg?resize=300%2C199" width="300" height="199" srcset="/wp-content/uploads/2013/11/Domain-PrivGroupMembership-Screenshot.jpg?resize=300%2C199 300w, /wp-content/uploads/2013/11/Domain-PrivGroupMembership-Screenshot.jpg?w=812 812w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][12]

### Conclusion

This script represents a good deal of work on my part so I&#8217;m thrilled to get any feedback or suggestions for improvement. If you browse through the code I think you will find a good deal to learn from (there are even some unused functions which do some neat things with LDAP paths tucked away in here).

### Downloads

**[Download from the technet gallery][13]**

 [1]: http://graphviz.org/
 [2]: https://code.google.com/p/graph-viz-portable/downloads/list
 [3]: wp-content/uploads/2013/10/Trusts-screenshot.jpg
 [4]: /wp-content/uploads/2013/10/trusts-screenshot2.jpg
 [5]: wp-content/uploads/2013/10/Lync-sreenshot.jpg
 [6]: /wp-content/uploads/2013/10/SiteSubnets-screenshot.jpg
 [7]: wp-content/uploads/2013/10/SiteConnections-screenshot.jpg
 [8]: wp-content/uploads/2013/10/ForestSummary-screenshot.jpg
 [9]: /wp-content/uploads/2013/10/DCs-Screenshot_thumb.jpg
 [10]: /wp-content/uploads/2013/11/Domain-Stats-Screenshot.jpg
 [11]: wp-content/uploads/2013/11/Domain-Groups-Screenshot.jpg
 [12]: /wp-content/uploads/2013/11/Domain-PrivGroupMembership-Screenshot.jpg
 [13]: http://gallery.technet.microsoft.com/Active-Directory-Audit-7754a877