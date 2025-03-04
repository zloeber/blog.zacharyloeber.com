---
title: Find Disabled Users With Lync Enabled Without Lync Cmdlts
author: Zachary Loeber
type: post
date: 2013-09-30T21:19:15+00:00
url: /blog/2013/09/30/find-disabled-users-with-lync-enabled-without-lync-cmdlts/
categories:
  - Active Directory
  - Lync
  - Microsoft
  - Powershell
tags:
  - Active Directory
  - Exchange 2010
  - Lync
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Windows

---
Here is a quick tip which applies to more than just Lync. I use powershell with .NET ADSI to gather a list of all users which are disabled but still have Lync sip addresses assigned. There are numerous reasons to disable lync on such accounts. One reason would be to make certain that users whom are no longer with the organization get removed from the Lync address list. Another is so these same users can no longer access Lync! (Yes, a disabled AD account may still be authorized to access Lync).

<!--more-->

It is a common misnomer that the Lync administration console is required to access basic Lync information. In all actuality, you need only have a domain user account and a bit of active directory acumen to report upon a whole bunch of Lync related attributes. And you can get even more information from AD about Exchange (See my article [comparing the level of AD reliance Lync and Exchange exhibit][1]).

Here is a small example on getting some of this kind of info. Essentially all we are looking for are accounts in AD with a disabled account but which still have a primary sip address assigned to the msRTCSIP-PrimaryUserAddress attribute.

Lets start with the disabled user part. An LDAP filter which will find all the disabled accounts is:

<pre>(objectCategory=person)(objectClass=user)(useraccountcontrol:1.2.840.113556.1.4.803:=2)</pre>

Ok, so now add in any account where  msRTCSIP-PrimaryUserAddress contains any value. Easy peasy&#8230;

<pre>(msRTCSIP-PrimaryUserAddress=*)</pre>

So the new LDAP filter becomes:

<pre>(objectCategory=person)(objectClass=user)(useraccountcontrol:1.2.840.113556.1.4.803:=2)(msRTCSIP-PrimaryUserAddress=*)</pre>

So with the magic filter at hand, all that is left to do is query AD with it. You actually don&#8217;t even need to do this with powershell. If so inclined, you can simply create a new advanced query in Active Directory Users and Computers:

[<img class="aligncenter size-medium wp-image-963" alt="ldap-aduc-filter" src="/wp-content/uploads/2013/09/ldap-aduc-filter.jpg?resize=300%2C270" width="300" height="270" srcset="/wp-content/uploads/2013/09/ldap-aduc-filter.jpg?resize=300%2C270 300w, wp-content/uploads/2013/09/ldap-aduc-filter.jpg?w=398 398w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]

This should instantly show you all your disabled accounts which are still associated with a primary sip address in ADUC. But I promised a powershell way to do this as well. Here it is, without any AD or Lync modules.

<pre>$ADS_UF_ACCOUNTDISABLE = 0x00002
$root = [ADSI]''
$search = [adsisearcher]$root
$search.PageSize = 2000
$search.Filter = '(&(&(&(objectCategory=person)(objectClass=user)(useraccountcontrol:1.2.840.113556.1.4.803:=2)(msRTCSIP-PrimaryUserAddress=*))))'
$colResults = $Search.FindAll()
$Output = @()
foreach ($i in $colResults)
{
 $ObjProps = @{
 Name = [string]$i.Properties.Item('Name')
 Disabled = [bool]([string]$i.Properties.Item('useraccountcontrol') -band $ADS_UF_ACCOUNTDISABLE)
 PrimarySipAddress = [string]$i.Properties.Item('msRTCSIP-PrimaryUserAddress')
 }
 $Output += New-Object psobject -Property $ObjProps
}</pre>

<pre>$Output</pre>

I added in a few items just for aesthetics (The actual sip address and proof that the account is in fact disabled) but it is easy to get the gist of what I&#8217;m doing here. Note that [ADSI]&#8221; is essentially the root of the default naming context, also known as the top of your domain. You can target other partitions to get other information though. Of particular interest is the configuration partition. You can quickly start querying the configuration partition with the following code:

<pre>$RootDSC = [adsi]"LDAP://RootDSE"
$ConfigNamingContext = $RootDSC.configurationNamingContext
$Root = [ADSI]"LDAP://$([string]$ConfigNamingContext)"</pre>

If you search the configuration partition for the following:

<pre>(&(objectClass=msRTCSIP-Pool))</pre>

And then return the dnshostname attribute, you will have effectively queried AD for all Lync pool names.

Or filter for internal lync server names:

<pre>Filter: (&(objectClass=msRTCSIP-TrustedServer))</pre>

<pre>Attribute: msrtcsip-trustedserverfqdn</pre>

Or find the Lync edge servers&#8230;

<pre>Filter: (&(objectClass=msRTCSIP-EdgeProxy))</pre>

<pre>Attribute: msrtcsip-edgeproxyfqdn</pre>

Well, you get the picture. AD is a very big open book for those who know where to look 🙂

&nbsp;

&nbsp;

 [1]: http://www.peters.com/blog/Lists/Posts/Post.aspx?ID=48
 [2]: wp-content/uploads/2013/09/ldap-aduc-filter.jpg