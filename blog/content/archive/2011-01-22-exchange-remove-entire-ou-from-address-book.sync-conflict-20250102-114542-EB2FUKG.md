---
title: 'Exchange: Remove entire OU from address book'
author: Zachary Loeber
type: post
date: 2011-01-22T17:51:51+00:00
excerpt: This script removes an entire OU of users from the address book, so make sure that all the users are disabled in the OU you will be running this against! :)
url: /blog/2011/01/22/exchange-remove-entire-ou-from-address-book/
categories:
  - Active Directory
  - Exchange
  - Microsoft
  - System Administration
  - vbscript/hta

---
Here is another script that I hacked together in part of an AD/Exchange cleanup task to remove disabled users from the address book. This script, more specifically, removes an entire OU of users from the address book, so make sure that all the users are disabled in the OU you will be running this against! 🙂

<!--more-->Save as a VBS file and run from your exchange server:

<pre>On Error Resume Next
Const ADS_SCOPE_SUBTREE = 2
Set objConnection = CreateObject("ADODB.Connection")</pre>

<pre>Set objCommand =   CreateObject("ADODB.Command")</pre>

<pre>objConnection.Provider = "ADsDSOObject"</pre>

<pre>objConnection.Open "Active Directory Provider"</pre>

<pre>Set objCommand.ActiveConnection = objConnection</pre>

<pre>objCommand.Properties("Page Size") = 1000</pre>

<pre>objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE</pre>

<pre>objCommand.CommandText = _</pre>

<pre>"SELECT ADsPath FROM 'LDAP://OU=Some 2nd level OU,OU=Some Top level OU,dc=corp,dc=contoso,dc=com' WHERE objectClass='User'"</pre>

<pre>Set objRecordSet = objCommand.Execute</pre>

<pre>objRecordSet.MoveFirst</pre>

<pre>Do Until objRecordSet.EOF</pre>

<pre>strContactPath = objRecordSet.Fields("ADsPath").Value</pre>

<pre>MsgBox (strContactPath)</pre>

<pre>Set objContact = GetObject(strContactPath)</pre>

<pre>objContact.MSExchHideFromAddressLists = TRUE</pre>

<pre>objContact.SetInfo</pre>

<pre>objRecordSet.MoveNext</pre>

<pre>Loop</pre>