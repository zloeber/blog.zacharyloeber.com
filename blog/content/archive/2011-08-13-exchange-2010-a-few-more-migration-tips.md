---
title: 'Exchange 2010: A Few More Migration Tips'
author: Zachary Loeber
type: post
date: 2011-08-13T23:43:04+00:00
excerpt: Here are a few more notes from the field to consider when you are planning your Exchange 2010 deployment and migration. Some of these items are good to know even after you have completed your migration and may help with overall system stability.
url: /blog/2011/08/13/exchange-2010-a-few-more-migration-tips/
wordbooker_options:
  - 'a:11:{s:18:"wordbook_noncename";s:10:"4513bd7e93";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:20:"wordbook_use_excerpt";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";s:17:"wordbook_new_post";s:1:"1";}'
wordbooker_extract:
  - Here are a few more notes from the field to consider when you are planning your Exchange 2010 deployment and migration. Some of these items are good to know even after you have completed your migration and may help with overall system stability.
categories:
  - Exchange 2010
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Microsoft
  - Networking
  - Powershell
  - System Administration
  - Windows

---
Here are a few more notes from the field to consider when you are planning your Exchange 2010 deployment and migration. Some of these items are good to know even after you have completed your migration and may help with overall system stability.

## <!--more-->

## Make Appropriate AV Exclusions

If you are using a third party anti-virus solution you will want to ensure that the appropriate directories are excluded from scans. Otherwise you could end up with less than optimal performance. The official article on such exclusions can be found [at Microsoft&#8217;s site.][1]

Here is a quick summary of some recommended exclusions for some of the more popular Exchange 2010 roles.

[Exchange 2010 directories for AV exclusion][2]

&nbsp;

## Tweak Your DAG

There are a number of things you can do to increase the resiliency of your DAG. I&#8217;ve only ever worked with DAGs spread across desperate physical locations but it wouldn&#8217;t hurt to consider these tweaks even in a same site configuration as well.

### Change Cluster Thresholds

Microsoft&#8217;s article on this process is [documented on their web-site][3]. The gist of the matter is that the cluster thresholds used by default are rather paltry. To help prevent unneeded database failovers you can manually change the threshold on each DAG member. To boost the thresholds to their maximum value run the following:

<pre><strong>cluster /prop SameSubnetDelay=2000:DWORD</strong></pre>

<pre><strong>cluster /prop CrossSubnetDelay=4000:DWORD</strong></pre>

<pre><strong>cluster /prop CrossSubnetThreshold=10:DWORD</strong></pre>

<pre><strong>cluster /prop SameSubnetThreshold=10:DWORD</strong></pre>

To verify the settings run the following:

<pre><strong>cluster /prop</strong></pre>

### Disable Advanced NIC Settings

Receive Side Scaling (RSS), [Chimney][4], and TCP Offload Engine (TOE) sound like cool technology to have enabled on your network interfaces but they tend to make exchange servers crabby. When theya re crabby they tend to have intermittent connectivity issues which makes your DAG do seemingly random fail-over issues. If you look in the failover cluster manager you will likely see errors about connectivity to the witness server. This can be exasperated in a multiple site DAG configuration as advanced nic features like RSS require end-to-end support to be used effectively.

To disable these features it is recommended to physically go into the advanced nic properties and manually disable each related setting as well as disable the setting at the OS level. I&#8217;ve only needed to do the OS level disabling by using the following commands at each DAG server AND on each witness server.

<pre><strong>netsh interface tcp set global rss=disabled</strong></pre>

<pre><strong>netsh interface tcp set global chimney=disabled</strong></pre>

<pre><strong>netsh interface tcp set global autotuninglevel=disabled</strong></pre>

## 

## Mailboxes Migrate Into Exchange 2010 as Linked Mailboxes

I saw this for a few clients, thought it was weird, so I&#8217;m posting it here 🙂

Basically there were extra attributes from some prior migration that was confusing Exchange 2010 during the migration. If you are certain that you are not using linked mailboxes then you can convert all linked mailboxes to user mailboxes in one line.

<pre>Get-Mailbox -RecipientTypeDetails LinkedMailbox | Set-User -LinkedMasterAccount $null</pre>

A Microsoft technician explained a bit more on what causes this to happen. He noted that the affected accounts have msExchMasterAccountSID populated prior to mailbox migration. This attribute should only be populated on disabled accounts that have an associated external account assigned permissions to the mailbox in Exchange 2003. Apparently you can fix this from happening by running [NoMAS in fix mode.][5]

&nbsp;

## You Get &#8220;This error is not retriable&#8221; When Migrating A Mailbox

So you are all ramped up and ready to start migrating your mailboxes to the environment you erected with much hard work, sweat, and tears. Everything is great until you see that several users refuse to migrate with an error like this:

<pre><strong>Active Directory operation failed on yourdc.corp.contoso.local. This error is not retriable. Additional information: Insu fficient access rights to perform the operation. Active directory response: 00002098: SecErr: DSID-03150BB9, problem 4003 (INSUFF_ACCESS_RIGHTS), data 0     + CategoryInfo          : NotSpecified: (0:Int32) [New-MoveRequest], ADOperationException     + FullyQualifiedErrorId : B959FFD3,Microsoft.Exchange.Management.RecipientTasks.NewMoveRequest</strong></pre>

What the heck does that mean? Well the Insufficient Access Rights portion of the error says it all. What you may find out is that user mailboxes which exhibit this error tend to not be inheriting permissions in active directory. Even if they are, it doesn&#8217;t hurt to reset the inheritance setting for the account and try again. You can do this in Active directory users and computers by making sure that the &#8220;Advanced&#8221; option is set in the view menu. Then select the account in question, go to the permissions tab, select advanced, and look for the permission inherited checkbox. Either uncheck, apply, recheck, apply or check the box and apply (depending if it is already selected or not). Try to migrate again and you should be golden.

Or if you are using the handy-dandy quest powershell cmdlts you can update the account with a single line:

<pre>Get-QADUser &lt;user&gt; | Set-QADObjectSecurity -LockInheritance</pre>

If you are looking for all the possible trouble accounts run the following for a quick report on those who are not inheriting their OU permissions:

<pre><strong>Get-QADUser -SizeLimit 0 | Select-Object Name,@{n='IncludeInheritablePermissions';e={!$_.DirectoryEntry.PSBase.ObjectSecurity.AreAccessRulesProtected}} | Where {!$_.IncludeInheritablePermissions} &gt; export-csv -notypeinformation c:\temp\not-inheriting.csv</strong></pre>

&nbsp;

## Arbitration Mailboxes May Not Always Be Setup Properly

This one is a bit of a nuisance,  but it is not a show stopper. You may not even notice that there is an issue with arbitration mailboxes until you want to use a feature which requires them to be 100% functional. For me it was finding out that I could not run admin audit logs but other symptoms of an issue might be that you [cannot moderate distribution list][6]s or perform discovery. If you find this to be the case then you may be running into an arbitration mailbox issue. I cannot help you if you accidentally deleted these essential mailboxes (ok, I can help you, just reprep your forest/domain, they will likely be recreated with no fanfare). If you find that you are unable to use these mailboxes you may just need to fix them. There are three arbitration mailboxes which get **stored at your forest root**:

  * **Discovery**&#8211; SystemMailbox{e0dc1c29-89c3-4034-b678-e6c29d823ed9}
  * **Message Approval** &#8211; SystemMailbox{1f05a927-xxxx-xxxx-xxxx-xxxxxxxxxxxx} (_where x is a random number_)
  * **Federated E-mail** &#8211; FederatedEmail.4c1f4d8b-8179-4148-93bf-00a95fa1e042

Firstly you might experience issues even seeing these mailboxes. If you are in an environment which follows best AD practices then your forest root is nearly empty and the production domain with all of your users and mailboxes is in a sub-domain of the forest root. You then do most of your work with a domain admin account in that sub-domain. In order to see the arbitration mailboxes you need to change the scope of your default view to include the entire forest in EMC. You will know that you need to do this if you run get-mailbox -arbitration and get an empty result with no errors. To get around this change your scope in EMC

<pre>Set-AdServerSettings -ViewEntireForest $true
Get-Mailbox -Arbitration</pre>

Unless you foolishly deleted your initial default mailbox or did something else wrong you should see your three federation mailboxes without any errors. If you do get errors they may look something like this:

<pre><span style="font-family: courier new;">WARNING: The object MyDomain.local/Users/SystemMailbox{1f05a927-xxxx-xxxx-xxxx-xxxxxxxxxxxx} has been corrupted, and it's in an inconsistent state. The following validation errors happened: WARNING: Database is mandatory on UserMailbox. </span></pre>

<span style="font-family: courier new;">I was confused when I first saw this error. When I looked up these accounts in adsiedit I found that their homeMDB attribute was totally blank. This was not my install so I&#8217;m not certain what was done to mash up the arbitration mailboxes so badly. To fix this is pretty simple though, find the correct homeMDB attribute value and assign it to the accounts. Then make sure that the account is enabled. What I did was looked at the homeMTA attribute and extrapolated what the homeMDB value was supposed to be.</span>

<span style="font-family: courier new;">You can get to the correct area in adsiedit by selecting the default naming context and making sure that your root domain name is used. Then, by default, these accounts will be located in the Users system object (or I can inaccurately say the Users OU, which it is not).</span>

I happened to be lucky. The homeMTA pointed to a server which was in production and all the databases were sequentially numbered. I guessed that the first database was the initial install database&#8230; and it was!

homeMTA looked like this:

<pre>CN=Microsoft MTA,CN=&lt;Your First Mailbox Server&gt;,CN=Servers,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=Your Corporation,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=contoso,DC=local</pre>

<pre>So I made homeMDB the following value:</pre>

<pre>CN=&lt;Your First Database&gt;,CN=Databases,CN=Exchange Administrative Group (FYDIBOHF23SPDLT),CN=Administrative Groups,CN=Your Corporation,CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=contoso,DC=local</pre>

My guess as to why this happened is that between the forest/domain preparations not enough time elapsed before continuing the server role installations in the sub-domain. That is purely a guess though as I wasn&#8217;t around when this particular install occurred and the person doing the install is no longer around. Should you need to recreate the arbitration mailboxes all together [here is a good site][7] covering how to do so.

&nbsp;

## Not All Issues Are Exchange Related

I think I&#8217;ve had to deal with just about every Outlook client related issue under the sun when doing Exchange 2010 mailbox migrations. People assume that every issue stems from Exchange and that is simply not the case. Outlook 2003/2007/2010 all behave differently and have their own unique issues to deal with. Here are some basic tips for fixing Outlook 2007/20100 issues (I&#8217;ve been lucky enough not to have to deal with Outlook 2003 as much).

### Repair Numerous Issues in Outlook 2007

This has fixed more unexplainable issues in outlook 2007 than I can even remember. It requires that your end user be out of outlook, any other office application, and office communicator while it runs. You may want to suggest starting this before lunch.

  1. Go to Help and select “Office Diagnostics…”

### Clean/Fix OST/PST files in Outlook 2007

  1. <a name="_GoBack"></a>Close both Outlook and Office Communicator
  2. Run C:\Program Files\Microsoft Office\Office12\SCANPST.EXE
  3. Browse for OST/PST files in &#8220;%userprofile%\Application Data\Microsoft\Outlook\&#8221; and run scanpst.exe against each of them.

### **Clean/Fix OST/PST files in Outlook 2010**

This is highly recommended if the user has just upgraded to Outlook 2010 from a prior version. No matter how good the SCCM package is that gets pushed to your end users Outlook will still have random and weird issues after being upgraded.

On 64-bit computer

C:\Program Files (x86)\Microsoft Office\Office14\SCANPST.EXE

On 32-bit computer

C:\Program Files\Microsoft Office\Office14\SCANPST.EXE

### **Repair Outlook 2007 profile**

  1. In Outlook 2007, from the Tools menu, click Account Settings.
  2. In the Account Settings dialog box, on the E-mail tab, select your account, and then click Repair. Follow any prompts from the repair wizard.
  3. When the repair is done, restart Outlook 2007.

### **Repair Outlook 2010 profile**

  1. In Outlook 2010, on the File tab, click the arrow next to Account Settings, and then click Account Settings.
  2. In the Account Settings dialog box, on the E-mail tab, select your account, and then click Repair. Follow any prompts from the repair wizard.
  3. When the repair is done, restart Outlook 2010.

### **Recreate Outlook Profile Snag (if you are forced to go as far as to recreate the profile)**

  1. After removing the default profile in outlook you will need to rename/move/delete &#8220;%userprofile%\Local Settings\Application Data\Microsoft\Outlook&#8221; for the user

### **Default location for outlook.exe 2010**

On 64-bit computer

C:\Program Files (x86)\Microsoft Office\Office14\outlook.exe

On 32-bit computer

C:\Program Files\Microsoft Office\Office14\outlook.exe

### **Default location for outlook.exe 2007**

On 64-bit computer

C:\Program Files (x86)\Microsoft Office\Office12\outlook.exe

On 32-bit computer

C:\Program Files\Microsoft Office\Office12\outlook.exe

### **Open Outlook With A Custom Flag**

From a run dialog box:

<pre>"c:\&lt;Outlook Location &gt;\outlook.exe" /&lt;command&gt;</pre>

### **Switches You Can Use With Outlook.exe (the /Clean* switches can be particularly useful)**

&nbsp;

[Here is a link to a reference table for Outlook 2007/2010 command-line switches.][8]

&nbsp;

 [1]: http://technet.microsoft.com/en-us/library/bb332342.aspx "Exchange 2010 AV Exclusion Technet Article"
 [2]: /wp-content/uploads/2011/08/exchange-av-table.html "Exchange 2010 AV Exclusion Table"
 [3]: http://technet.microsoft.com/en-us/library/dd197562(WS.10).aspx "cluster thresholds"
 [4]: http://support.microsoft.com/kb/951037 "MS Chimney Article"
 [5]: http://archive.msdn.microsoft.com/NoMas "NoMAS Download"
 [6]: http://technet.microsoft.com/en-us/library/dd297936%28EXCHG.140%29.aspx "Arbitration mailboxes and moderation"
 [7]: http://msundis.wordpress.com/2010/08/17/recreate-and-enabled-missing-arbitration-user-accounts-and-mailboxes/ "Recreate Arbitration Mailboxes"
 [8]: /wp-content/uploads/2011/08/Outlook-Flags.html "Outlook 2007/2010 command line arguments"