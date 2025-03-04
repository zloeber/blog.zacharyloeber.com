---
title: 'Google Charts: Interactive Visualization with Powershell'
author: Zachary Loeber
type: post
date: 2013-12-17T02:11:52+00:00
excerpt: In this script I use powershell to gather system volume information which is then converted into a javascript array. This array is fed into the google charts to create a semi-attractive visualization of server disk space utilization in a single html report. Although this approach is a bit unconventional the results are both fun and useful.
url: /blog/2013/12/16/google-charts-interactive-visualization-with-powershell/
featured_image: /wp-content/uploads/2013/12/2013-12-16-13_56_57-test.html_-200x150.png
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Drive Space
  - Google Charts
  - HTML Report
  - Javascript
  - Powershell
  - PSC

---
In this script I use powershell to gather system volume information which is then converted into a javascript array. This array is fed into the google charts to create a semi-attractive visualization of server disk space utilization in a single html report. Although this approach is a bit unconventional the results are both fun and useful.

<!--more-->

### Introduction

Everyone likes a good visualization. A decent chart can turn boring data into something meaningful or at the very least reduce eye strain when discerning meaning from a data set. Because of this I was looking into what it would take to create html reports with charts and other visualizations without dlls or other dependencies. The first method I discovered was the [Google Image Charts API.][1] There are people who have written whole dashboards around these handy charts. There are a few unfortunate down sides to using the Google Image Charts API though;

  1. You have to send your data outside of your organization
  2. There is little interactivity
  3. In 2015 the Google Image Charts API will be depreciated

To get around these drawbacks I’ve started tinkering with the Google Charts API. The primary difference from the Google Image Charts API is that all the charts are rendered in the client browser using code embedded from Google. This means all the data is kept local and there is a greater degree of interactivity which can be implemented.

In order to use the Google Chart elements you will first need to feed your data into javascript. As I’m looking to keep things simple and am not trying to create a full AJAX project, I fabricated a function which will take an array of psobjects and convert the psobject NoteProperty elements into a javascript array:

<pre class="wrap:true lang:powershell decode:true" title="ConvertTo-JSArray">Function ConvertTo-JSArray 
{
    &lt;#
    .SYNOPSIS
    Convert an array of PSObjects to a javascript array.
    .DESCRIPTION
    Convert an array of PSObjects to a javascript array. Only NoteProperty values will be included in the results.
    .PARAMETER InputObject
    An array of psobjects to convert.
    .PARAMETER IncludeHeader
    This will add the NoteProperty Name as the topmost element of the array.
    .EXAMPLE
    DriveInfo | ConvertTo-JSArray -IncludeHeader
    .NOTES
        Version    : 1.0.0 12/13/2013
                     - First release
        Author     : Zachary Loeber
    .LINK
        http://zacharyloeber.com/
    .LINK
        http://nl.linkedin.com/in/zloeber
    #&gt; 
    [cmdletbinding()]
    PARAM
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [PSObject]
        $InputObject,

        [switch]
        $IncludeHeader
    )

    BEGIN
    {
        #init array to dump all objects into
        $AllObjects = @()
        $jsarray = ''
        $header = ''
    }
    PROCESS
    {
        $AllObjects += $InputObject
    }
    END
    {
        $objcount = 0
        ForEach ($obj in $AllObjects) 
        {
            $properties = @($obj.psobject.properties | Where {$_.MemberType -eq 'NoteProperty'})
            if ($properties.Count -gt 0)
            {
                $propcount = 1
                $arrayelement = ''
                $objcount++
                ForEach($property in $properties)
                {
                    switch ($property.TypeNameOfValue)
                    {
                        'System.String' {
                            # escape the escape characters
                            $strval = ($property.Value).replace('\','\\')
                            $arrayval = "'$($strval)'"
                        }
                        default {
                            $arrayval = $property.Value
                        }
                    }
                    # if this is not the last property then add a comma
                    if ($properties.count -ne $propcount)
                    {
                        $arrayval = "$arrayval,"
                    }
                    $arrayelement = $arrayelement+$arrayval
                    $propcount++
                }
                $arrayelement = "[$arrayelement]"
                # if this is not the last property then add a comma
                if ($AllObjects.count -ne $objcount)
                {
                    $arrayelement = "$arrayelement,"
                }
                $jsarray = $jsarray + $arrayelement
            }
        }
        if ($IncludeHeader)
        {
            $headerpropcount = 0
            $headerprops = @(($AllObjects[0]).psobject.properties | Where {$_.MemberType -eq 'NoteProperty'} | %{$_.Name})
            Foreach ($headerprop in $headerprops)
            {
                $headerpropcount++
                $header = $header + "'$headerprop'"
                # if this is will be followed by array elements then add a comma
                if (($headerpropcount -ne $headerprops.count))
                {
                    $header = "$header,"
                }
            }
            if ($jsarray -eq '')
            {
                $header = "[$header]"
            }
            else
            {
                $header = "[$header],"
            }
        }
        return "[$($header)$($jsarray)]"
    }
}</pre>

From there it is just a matter of getting data I want to report upon properly represented in the portal html template. In order to do this I actually create the data structure first (using the previously generated array), then use a few data views, one for the table and one for the chart. This allows us not only to use the same data in the chart table and bar chart elements but also lets us customize the element styles and other roles. Simply select the columns you want to use and which role they play. Here is an example of pulling view data for a chart element where I include both style and roles to change the color of the bars and overlay annotations:

<pre class="lang:js decode:true">customchartview.setColumns([0, 5, {sourceColumn: 9,role:'style'}, {sourceColumn: 7,role:'annotation'}, 6, {sourceColumn: 10,role:'style'}, {sourceColumn: 8,role:'annotation'}]);</pre>

So we use column 0 and 5 as normal data elements, then use columns 9 and 7 as a style and annotation respectively. Since we are stacking bar chart data we then add in column 6 as regular data and do the same trick with style/annotation with columns 10 and 8.

In the powershell code the ‘columns’ are all defined in order by selecting them from the output of another function I’ve included to gather local or remote disk information. This is worthy of looking at because I pull off two additional powershell tricks:

<pre class="wrap:true lang:powershell decode:true"># Report elements to select
$DiskReportElements = @('Drive',
                        'Disk',
                        'DiskType',
                        'Model',
                        'DiskSize',
                        'PercentUsed',
                        'PercentFree',
                        'UsedSpace',
                        'FreeSpace',
                        @{n='UsedStyle';e={ if ($_.PercentUsed -gt $DriveusageAlert)
                                            {
                                                'red'
                                            }
                                            elseif ($_.PercentUsed -gt $DriveUsageWarn)
                                            {
                                                'orange'
                                            }
                                            else
                                            {
                                                'green'
                                            }
                                          }},
                        @{n='UnUsedStyle';e={'black'}})
$DriveInfo = @(Get-RemoteDiskInformation  | 
                Where {$_.Drive} | 
                    Select $DiskReportElements)</pre>

The first trick is that I define all the object properties I’m going to later select in $DiskReportElements. This is useful for more easily tracking the object properties you are working with in larger selections of data. Within this list of properties I pull off another trick of performing inline logic to determine the value of the UsedStyle member. In this case UsedStyle is ‘green’ by default, becomes ‘orange’ if disk utilization percent is above $DriveUsageWarn, and is ‘red’ if the disk utilization percent is above $DriveUsageAlert. If you have been reading up to this point and counted the number of elements in my selection you will see that ‘UsageStyle’ is our 10th item, that conveniently matches up with {sourceColumn: 10,role:&#8217;style&#8217;} in the javascript template I’ve defined.

### Screenshots

##### [<img style="margin: 5px; display: inline; background-image: none;" title="2013-12-16 13_56_57-test.html" alt="2013-12-16 13_56_57-test.html" src="/wp-content/uploads/2013/12/2013-12-16-13_56_57-test.html_thumb.png?resize=566%2C152" width="566" height="152" border="0" data-recalc-dims="1" />][2]

##### 

### Notes

  * Although the report does work in IE, I&#8217;ve found that sometimes the browser will need to be refreshed to get the chart elements to render properly.
  * If you sort the columns in the chart table, the bar charts sort as well!
  * You can easily modify this to use the disk information function for remote system drive reports instead.
  * I use some google chart trickery to create the bar charts both stacked and with no margins in order to make it appear to be a utilization bar instead.
  * The charts have mouse over effects for both the annotations (for used and unused space) and percentage utilization.
  * I didn&#8217;t add much flair to this script as it was put together in the midnight hours as an intellectual exercise more than anything (after my crabby teething children finally fall asleep).

### Download

You can get the script in its entirety [at the Microsoft Technet Gallery][3].

 [1]: https://developers.google.com/chart/image/
 [2]: wp-content/uploads/2013/12/2013-12-16-13_56_57-test.html_.png
 [3]: http://gallery.technet.microsoft.com/Google-Charts-Interactive-87327b40