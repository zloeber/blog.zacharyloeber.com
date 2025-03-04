---
title: 'PowerShell: AzureAD Dynamic Groups'
author: Zachary Loeber
type: post
date: 2018-02-04T17:36:57+00:00
url: /blog/2018/02/04/powershell-azuread-dynamic-groups/
categories:
  - Active Directory
  - Azure
  - Microsoft
  - Office 365
  - Powershell
  - System Administration
tags:
  - Office 365
  - Powershell
  - Powershell Script
  - Scripting
  - System Administration

---
A few code snippets for Azure AD dynamic groups. One for creating standard groups for your environment. Another for finding duplicates.

<!--more-->

I&#8217;ve implemented InTune for our corporate environment and handed it off to someone else to manage. This person did a great job of managing things despite the fact that InTune underwent several backend migrations and updates that either broke or left unpredictable software distribution groups in the environment. I&#8217;ve finally found a few cycles to round back on this one and found some funny things.

Essentially, there were around 90 dynamic groups auto-created called &#8220;Subsidiary*&#8221; that were almost all duplicates of the same dynamic filter including all computers in the environment. It was bizarre and confusing but also understandable (as we didn&#8217;t heed the InTune upgrade warnings and take necessary actions at the time). Anyway, this led me to want to create some standard dynamic groups as well as find and remove the duplicates.

For adding the new groups you can [use this gist][1]. This is easily modified to add or remove groups of your choosing. This didn&#8217;t really warrant a new module or anything so there are some built in variables that control whether existing dynamic groups are updated or left alone when this script runs. This would be a decent candidate for scheduling to be run via Azure Automation on a regular basis.

<pre class="lang:powershell decode:true" title="Create Standard Azure AD Dynamic Groups" data-url="https://gist.githubusercontent.com/zloeber/de30502faa6cf48b7288479272fae3c8/raw/a1f400e1776fdcfa40baa8759d3ce575dc2d2930/CreateAzureADDynamicGroups.ps1"></pre>

For finding your duplicate dynamic groups [use this gist][1]. This will not find all duplicate filters but it will find the most common ones and is a good starting point.

<pre class="lang:powershell decode:true" title="List Duplicate Azure AD Dynamic Groups" data-url="https://gist.githubusercontent.com/zloeber/0394b41b41740ff59461688663f35d2a/raw/21bae291a1707df89ac6f956d16fce5ee4a1fce6/GetDuplicateAzureADDynamicGroups.ps1"></pre>

Reminder that the dynamic group cmdlets are only functional in the AzureADPreview module. You may have to explicitly load this module so AzureAD doesn&#8217;t interfere with things and cause a bunch of errors to get thrown (this is seen in the code at the beginning where I force remove AzureAD and load AzureADPreview).

 [1]: https://gist.github.com/zloeber/0394b41b41740ff59461688663f35d2a