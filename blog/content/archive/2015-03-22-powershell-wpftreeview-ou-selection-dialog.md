---
title: 'Powershell: WPF/Treeview OU Selection Dialog'
author: Zachary Loeber
type: post
date: 2015-03-22T16:13:54+00:00
url: /blog/2015/03/22/powershell-wpftreeview-ou-selection-dialog/
categories:
  - Active Directory
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
<p class="projectSummary">
  This is a self-contained organizational unit selection dialog box using powershell, xaml, wpf, and ADSI. Should be useful in any number of one off Powershell projects I imagine.
</p>

<p class="projectSummary">
  <!--more-->
</p>

<pre class="lang:powershell decode:true ">&lt;# 
    .SYNOPSIS 
    A self contained WPF/XAML treeview organizational unit selection dialog box. 
    .DESCRIPTION 
    A self contained WPF/XAML treeview organizational unit selection dialog box. No AD modules required, just need to be joined to the domain. 
    .EXAMPLE 
    $OU = Get-OUDialog 
    .NOTES 
    Author: Zachary Loeber 
    Requires: Powershell 4.0 
    Version History 
    1.0.0 - 03/21/2015 
        - Initial release (the function is a bit overbloated because I'm simply embedding some of my prior functions directly 
          in the thing instead of customizing the code for the function. Meh, it gets the job done... 
    .LINK 
    https://github.com/zloeber/Powershell/blob/master/ActiveDirectory/Select-OU/Get-OUDialog.ps1 
    .LINK 
    http://zacharyloeber.com 
    #&gt;</pre>

<p class="endscriptcode">
  Because I was lego building my other bits of code together for this function I do a few slightly wonky things to populate the treeview properly. I first generate a json exportable object of the tree based on CanonicalName of the OUs. Then I recursively create listitems with the data using the CanonicalName as the tag data. Then I return distinguishedName as the results by converting the CN to DN again with a super fast and dirty hack function. So, goal acccomplished but in a round about way.
</p>

<p class="endscriptcode">
  There are some also rather largish functions included in this example for what was to be the beginning of a generic ADSI library. I use these to query AD to avoid any dependencies on the AD cmdlets (at the expense of blowing up the overall script size by quite a bit).
</p>

<p class="endscriptcode">
  Anyway, I uploaded this to the <a href="https://gallery.technet.microsoft.com/Powershell-WPFTreeview-OU-addcb876">technet script gallery</a> and <a href="https://github.com/zloeber/Powershell/blob/master/ActiveDirectory/Select-OU/Get-OUDialog.ps1">my github repo</a>.
</p>