---
title: 'Powershell Tip: Save and Load Calculated Property Definitions'
author: Zachary Loeber
type: post
date: 2014-02-10T04:34:49+00:00
excerpt: 'Powershell Tip: Save and Load Calculated Property Definitions'
url: /blog/2014/02/09/powershell-tip-save-and-load-calculated-property-definitions/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Calculated Properties
  - Export-CliXML
  - Import-CliXML
  - Powershell
  - PSC

---
Using Export-CliXML and Import-CliXML (as well as some custom code) you can save calculated properties in a file for later use. Although the need for something like this is rather infrequent the exercise can better familiarize you with multiple Powershell techniques and concepts.

<!--more-->

### Intro

I’ve picked up quite a bit of PowerShell know how over the course of the last few years. I’m going to try and round back to some of the more interesting tricks I’ve picked up and share them in a series of quick tip articles.&nbsp; This first one I recently discovered as a method to store, then later load, [calculated property][1] definitions.

Why would I want to do this? Well a few of my recent projects have involved gathering a large amount of data from either computers or AD and then regurgitating the data into one of several reports. So the same data element may be split by a carriage return for an excel report or a <br /> for an html report (as a small example). In order to accommodate this functionality I chose to bundle in all the report element output in one big hash which also includes the report section data and several other bits of logic.

Here is an example of one report section where the same data is used for two different types of reports.

<pre>$Report = @{
  'ReportTypes' = @{
	   'ExcelExport' = @{ 
		 'ContainerType' = 'Full' 
		 'SectionOverride' = $false 
		 'TableType' = 'Horizontal' 
		 'Properties' = 
			  @{n='Name';e={$_.virtualserver}}, 
			  @{n='Address';e={$_.address}}, 
			  @{n='Port';e={$_.port}}, 
			  @{n='Pool';e={$_.pool}}, 
			  @{n='Enabled';e={$_.enabled}}, 
			  @{n='Availability';e={$_.availability}}, 
			  @{n='Persistence Profile';e={[string]$_.persistenceprofile -replace ' ', "`n`r"}}, 
			  @{n='Rules';e={[string]$_.rules -replace ' ', "`n`r"}} 
	   } 
	   'FullDocumentation' = @{ 
		  'ContainerType' = 'Full' 
		  'SectionOverride' = $false 
		  'TableType' = 'Horizontal' 
		  'Properties' = 
			  @{n='Name';e={'&lt;a id="{0}"&gt;{0}&lt;/a&gt;' -f $_.virtualserver}}, 
			  @{n='Persistence Profile';e={[string]$_.persistenceprofile -replace ' ', "&lt;br /&gt;`n`r"}}, 
			  @{n='Rules';e={[string]$_.rules -replace ' ', "&lt;br /&gt;`n`r"}} 
		} 
   }
}</pre>

Later on I select the report section data using the calculated properties for the report I want to create like this:

<pre>$SectionData = $ReportData | Select $Report[‘ReportType’][‘FullDocumentation’][‘Properties’]</pre>

### Calculated Properties

Calculated properties are simply two element hashes with a label and an expression (technically you only need the expression but that expression becomes the element label and that’s ugly). The label key can be &#8220;Name&#8221;,&#8221;Label&#8221;,&#8221;n&#8221;, or &#8220;l&#8221; and the value is a string. The expression key can be &#8220;Expression&#8221; or just &#8220;e&#8221; and its value is a scriptblock (so it must be surrounded by curly braces).

It should be noted that there is nothing special about calculated properties when you define them in separate variables. You are simply defining an array of hashes. In the example code above I could have also written the calculated properties like this:

<pre>'Properties' = @(@{n='Name';e={'&lt;a id="{0}"&gt;{0}&lt;/a&gt;' -f $_.virtualserver}},
@{n='Persistence Profile';e={[string]$_.persistenceprofile -replace ' ', "&lt;br /&gt;`n`r"}},
@{n='Rules';e={[string]$_.rules -replace ' ', "&lt;br /&gt;`n`r"}})</pre>

### Getting To The Point

Ok, so how do we save calculated property definitions into an external file? With most data exports that involve basic arrays or psobjects I’d use Export-CSV&nbsp; Whenever you are looking to save hash data into files your go to command will be Export-CliXML. Export-CliXML will export hash information into an XML format which represents the hash for an almost perfect re-import with Import-CliXML.

Notice I said, “almost perfect”. Export-CliXML is not going to recognize the expression as the scriptblock it is meant to be. Instead it will save it as a plain string. When you re-import the calculated properties you need to convert all the expressions back to a scriptblock otherwise when you use them you will simply get empty results. Here is the example code I put together which shows the top 5 memory consuming processes and the percentage they are utilizing. I create a separate variable which holds the calculated properties, export it to a save file, then import the file into a different variable, update each expression in the resulting array of hashes to be scriptblocks, and then finish by using the resulting variable.

<pre>$SaveFile = 'C:\Temp\saveprops.xml' 
$TotalMem = (Get-WMIObject -class 'Win32_ComputerSystem').TotalPhysicalMemory 
$MemUsageProp = @{n='Name';e={$_.ProcessName}}, 
@{n='MemoryUsage';e={[math]::Round((($_.WS/$TotalMem)*100),2)}}
Export-Clixml -InputObject $MemUsageProp -Path $SaveFile
$MemUsageProp2 = Import-Clixml -Path $SaveFile
$MemUsageProp2 | ForEach { 
   $_['e'] = [Scriptblock]::Create($_['e']) 
}
Get-Process | 
  Sort-Object -Property WS -Descending&nbsp;| 
  Select-Object $MemUsageProp2 -First 5</pre>

This is a pretty simple example but if we were embedding the calculated properties with several other elements you would have to customize this to fit your needs. Also notice that I only target the &#8216;e&#8217; element for converting into a scriptblock. It should be a nominal effort to update this to include the &#8216;expression&#8217; element as well.

 [1]: http://technet.microsoft.com/en-us/library/ff730948.aspx