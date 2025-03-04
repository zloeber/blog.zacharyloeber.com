---
title: Microsoft Unified Access Gateway 2010 Notes
author: Zachary Loeber
type: post
date: 2010-08-02T19:11:42+00:00
excerpt: If you are new to the Microsoft Unified Access Gateway then you really should be aware of these things I ran into while trying to get my array setup and running smoothly. Sure, to find my single post among the masses is probably not going to happen, but if you do find it before you start your endeavor then I promise you will be saved a bit of time and frustration. The first major frustration, the installation...
url: /blog/2010/08/02/microsoft-unified-access-gateway-2010-notes/
categories:
  - Microsoft
  - Networking
  - System Administration
  - Unified Access Gateway

---
If you are new to the Microsoft Unified Access Gateway then you really should know some of these things I ran into while trying to get my array setup and running smoothly. Sure, to find my single post among the masses is probably not going to happen, but if you do find it before you start your endeavor then I promise you will be saved time and frustration. The first major frustration, the installation&#8230;.

<!--more-->

### 1.) Install UAG 2010 from RDP:

Yup, you read that right, just do it and you will save yourself some frustration right form the start. If you install from a console (in my case a slow vmware consol) then some of the automatic rules which might help you out never get put in place and you have to do them manually. The remote desktop is an admins window to their responsibilities. If you install UAG 2010 from it, the rules that allow you to access your new reverse proxy are created automatically. Otherwise you have to manually add the rules inside of the Threat Management Gateway console before you can have your remote bliss.

### 2.) Get all servers to the same update level..then create your array:

This seems logical enough but I thought that the Unified Access Gateway, a pinnacle of technology from Microsoft, would be able to handle (and possibly even sync updates) between members of the same array. WRONG! That does not happen. Get them all to update 1 (at the time of this writing) then get to building your array.

### 3.) Speaking of updates&#8230;.msp files need to run as admin:

This is more of a general windows 2008 tip. Yeah, so a MSP file literally stands for an &#8220;MSI Patch&#8221; which is written long hand as &#8220;MicroSoft Installer Patch&#8221;.. or something like that. So you would think that in 2008 (R2) you could right click and run as an administrator to install Update 1 for UAG. Nope. To install this (and other install files that are giving you problems for that matter), right click on cmd.exe in your start menu and choose to &#8220;Run as Administrator&#8221;. Then CD to the place where the MSP is located and run from there. I&#8217;ve had to tell this to countless of my coworkers less versed in Microsoft&#8217;s strange logic and it has amazed them all. I know that there are registry entries to accomplish this same goal, in fact I have such a reg hack for HTA files somewhere in my collection that I&#8217;ll have to dig up and post some time.

### 3.) Know your routes, know your IP&#8217;s:

This seems logical as well. But if you don&#8217;t think you can get the courage up to just put it all in a document for the next poor soul who has to administer the damn thing then please at least use this [UAG_Workbook][1] (for a two server array, copy and paste worthy to any number of nodes of course).

### 4.) Requesting internal certificates for testing? Some major caveats:

&#8211; Your certificate private keys will need to be requested as exportable if they are part of an array. If it does not have that little key in the upper left corner of it&#8217;s icon in the local machine certificate store within the mmc console you did something wrong.

&#8211; Although the certificates should sync automatically in an array, it never hurts to double check if it was actually done or not. I found UAG refused to sync a cert a few times. I am not certain if it was me or UAG but after a manual export of the cert **(with the private key!)** from one server and import into another things started working as they should.

&#8211; If you want to test serving internal certificates through your external UAG interfaces you will need to hack the registry to make it happen. Copy and paste the following into a .reg file to work this magic. Apply to each server and reboot.

`Windows Registry Editor Version 5.00<br /> [HKEY_LOCAL_MACHINE\SOFTWARE\WhaleCom\e-Gap\von\UrlFilter\Comm\SSL]<br /> "ValidateRwsCert"=dword:00000000<br /> "ValidateRwsCertCRL"=dword:00000000<br />` 

&#8211; If you want to request a certificate from the UAG server to an internal PKI you will want to do so from the command line and with the certreq -submit -rpc command (basically request without using rpc as TMG has some filters and such in place locally that will prevent it from working.

First create a file like the following and save as ssl.inf   
`[Version]<br /> Signature="$Windows NT$"<br /> [NewRequest]<br /> Subject = "CN=ext.contsoso.com"   ; For a wildcard use "CN=*.CONTOSO.COM" for example<br /> ; For an empty subject use the following line instead<br /> ; Subject =<br /> Exportable = TRUE		    ; Private key is not exportable<br /> KeyLength = 2048                    ; Common key sizes: 512, 1024, 2048, 4096, 8192, 16384<br /> KeySpec = 1                           ; AT_KEYEXCHANGE<br /> KeyUsage = 0xA0                     ; Digital Signature, Key Encipherment<br /> MachineKeySet = True              ; The key belongs to the local computer account<br /> ProviderName = "Microsoft RSA SChannel Cryptographic Provider"<br /> ProviderType = 12<br /> SMIME = FALSE<br /> RequestType = CMC<br /> ; At least certreq.exe shipping with Windows Vista/Server 2008 is required to interpret the [Strings] and [Extensions] sections below<br /> [Strings]<br /> szOID_SUBJECT_ALT_NAME2 = "2.5.29.17"<br /> szOID_ENHANCED_KEY_USAGE = "2.5.29.37"<br /> szOID_PKIX_KP_SERVER_AUTH = "1.3.6.1.5.5.7.3.1"<br /> szOID_PKIX_KP_CLIENT_AUTH = "1.3.6.1.5.5.7.3.2"<br /> ; These will be your Subject alternative names<br /> %szOID_SUBJECT_ALT_NAME2% = "{text}dns=ext.contsoso.com&dns=san1.ext.contsoso.com&dns=san2.ext.contsoso.com"<br /> %szOID_ENHANCED_KEY_USAGE% = "{text}%szOID_PKIX_KP_SERVER_AUTH%,%szOID_PKIX_KP_CLIENT_AUTH%"<br /> [RequestAttributes]<br /> CertificateTemplate = CertificateWebTemplateWithoutSpaces ;"Certificate Web Template Without Spaces"`   
For the above file run the following commands to get and import your certificate:   
`certreq -new ssl.inf ssl.req<br /> certreq -submit -rpc ssl.req ssl.cer<br /> certreq -accept -machine ssl.cer`

### 5.) If you have a custom OU structure for AD you will have to customize your base search root:

UAG will try to be intelligent and select a base DN that makes sense to it. But if you don&#8217;t create all your users in the Users OU that doesn&#8217;t help much. So change your base DN (search root) on a new authentication server being configured to the correct location where you will be authenticating users from.

### 6.) You may have to restart IIS after activation:

At least I had to do so. It would even show in the web monitor that the nodes in my array were synced and all ready to start serving up the goodness. But I&#8217;d find that one or even both of the load balanced nodes would not reflect the changes I had made until IIS was restarted. Weird.

 [1]: /wp-content/uploads/2010/08/UAG_Workbook_Blank1.xlsx