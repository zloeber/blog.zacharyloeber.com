---
title: 'Powershell: System Report Script Design'
author: Zachary Loeber
type: post
date: 2014-10-09T21:29:24+00:00
excerpt: 'Powershell: Windows System Reports Script Design'
url: /blog/2014/10/09/powershell-system-report-script-design/
categories:
  - Microsoft
  - Networking
  - Powershell
  - Security
  - System Administration
tags:
  - Powershell
  - PSC
  - System Administration

---
In this post I go back and explain some of my reasoning behind decisions I made in the design of an already released script, [Get-AssetReport][1]. This was written over a year ago and forgotten about as one of the many unpublished drafts on my blog. The code behind the script I discuss has been upgraded and used in several of my more popular scripts ([AD Asset Report][2], [F5 LTM Report][3], and [Lync 2013 Status Report][4]). Some of this content is slightly dated as I&#8217;ve since changed some of the coding but the core concepts are the same. Those digging through my crazy work or learning powershell may get some value from this content so I tidied it up a bit and here it is. Cheers!

<!--more-->

## Introduction

I finally updated one of my [first powershell script releases][5], the venerable html system report. My updated version is a total rewrite of the first script with several additional benefits such as; multi-runspace asset gathering capabilities, a more modular and extendable design, and new output formatting options (including a responsive design grid layout and export to excel). If I were to summarize this script I&#8217;d term it as; &#8220;A powershell driven, mostly multi-threaded, system report gathering and rendering script with a high level of customization and beautiful output.&#8221;

<span style="line-height: 1.6;">This set of scripts and functions are still not perfect, but I have at least tried to set the stage for further expansion and development. In fact, this initial release is considered alpha because it is the raw format I tend to start with in my scripts before adding more refined features and better variable handling. The final steps (if I get that far) are to overlay everything with a GUI and I’m very far from that stage of this personal project. But the results have turned out so well thus far that I have decided to release what has already been done up to this point. That is why this is &#8220;Part 1&#8221;, I intend for this to be just the start of a well rounded systems reporting script to meet several needs.</span>

## Design Decisions

I initially looked at the report output from my original script (which was just a re-hacked up report of another author) and was going to re-use a good part of the CSS and code as a baseline to start this new script. But I eventually scrapped just about everything and started rewriting essential portions one at a time. I created a [multi-threaded system asset gathering][6] function to pull only the essential WMI information from a remote system. I then did the same for a [remote registry gathering function][7]. I took the html driven bar graph portion of the prior code, cleaned it up, made it highly portable, and [released it][8] as well.

I then started looking into how I wanted the report to look when completed. I really like this new responsive design fad that is going on (trying to design one web site which dynamically adapts to many devices and screen sizes). And I really think grids are slick. So I found a [really good responsive design based grid template][9] with as little reliance on javascript as possible and based the initial report output upon its CSS magic.

Part of the reason I used this particular author&#8217;s template is the extremely intuitive manner which he uses DIVs to layout the pages. Essentially you have a container with any number of elements within it to make up the columns. These columns are aptly given class names such as 2\_of\_3 or 1\_of\_2 (two thirds of the screen used and 1 half of the screen used respectively). This makes parsing the sections fairly easy so I can dynamically create new containers on the fly. What I do is create a hash with the type of divs which may be used in the report. (I&#8217;ve pruned out just the CSS elements for providing 1, 2, and 3 column output even though the template supports many more).

<pre class="lang:powershell decode:true  ">$SectionContainers = @{
 'Half' = ''
 'Full' = ''
 'Third' = ''
 'TwoThirds' = ''
 'Tail' = ''
}</pre>

<span style="line-height: 1.6;">Ok, so now that I know which css template I&#8217;m going to use, what other report output formatting might I desire to see? While the fancy responsive design template I&#8217;ll be using looks great in a web browser it tends to look sparse and visually unappealing in an outlook email. This is largely because Outlook will render html the same way that Word does, like crap. I mean, it only understands very basic CSS at best. So for every HTML section I&#8217;d like to be able to define multiple definitions based on how I decide to render the report output. I again lean on hash tables to make this easier to reference in the code later on:</span>

<pre>$HTMLRendering = @{
	'Header' = @{
		'DynamicGrid' = ''
		'EmailFriendly' = ''
	}
	'Footer' = @{
		'DynamicGrid' = ''
		'EmailFriendly' = ''
	}
}</pre>

If I&#8217;m rendering the header I would then simply use a single global variable to change how the entire report gets rendered like so:

<pre>$HTMLRendering['Header'][$RenderMode]</pre>

<span style="line-height: 1.6;">What else might I like to see in an all purpose html system report generation tool? As I was thinking about this I realized that there are very valid times when you want a report element to either be vertical or horizontal. For instance, a detailed system report might contain 20 properties in the summary which you don&#8217;t want spanning across the screen. In these cases I&#8217;d like the output to be in a horizontal table. I also may just want a threshold of properties to be reached before the report element automatically converts to a vertical format. So I accounted for the following three states.</span>

  * **horizontal** = Labels are in the first row
  * **vertical** = Labels are in the first column
  * **dynamic** = Report will be horizontal until it reaches a predefined threshold of properties, at which point it will transform and become vertical.

I also may create vastly different reports based on the same data. An example would be a daily troubleshooting report which contains a subset of system information you may want to have in a portal (or sent to your inbox) for daily examination. But I still want to easily create a full documentation report on a whim with the same information in a less filtered state. In order to accomplish this flexibility I accounted for different report types and properties. The resulting hash table looks a bit like this example for the summary portion of a report:

<pre>$ReportOptions =
@{
    'Summary' = @{
       'Enabled' = $true
       'AllowEmptyReport' = $true
       'Order' = 1
       'AllData' = @{}
       'Title' = "System Summary"
       'ContainerType' = 'Half'
       'TableType' = 'Vertical'
       'ReportProperties' = @{
          'Troubleshooting' = 
             @{n='Uptime';e={$_.Uptime}},
             @{n='OS';e={$_.OperatingSystem}},
             @{n='Virtual';e={$_.IsVirtual}},
             @{n='Total Physical RAM';e={$_.PhysicalMemoryTotal}},
             @{n='Free Physical RAM';e={$_.PhysicalMemoryFree}},
             @{n='Total Virtual RAM';e={$_.VirtualMemoryTotal}},
             @{n='Free Virtual RAM';e={$_.VirtualMemoryFree}}
          'FullDocumentation' = 
             @{n='OS';e={$_.OperatingSystem}},
             @{n='OS Architecture';e={$_.OSArchitecture}},
             @{n='OS Service Pack';e={$_.OSServicePack}},
             @{n='OS SKU';e={$_.OSSKU}},
             @{n='OS Version';e={$_.OSVersion}},
             @{n='Server Chassis Type';e={$_.ChassisModel}},
             @{n='Server Model';e={$_.Model}},
             @{n='CPU Architecture';e={$_.SystemArchitecture}},
             @{n='CPU Sockets';e={$_.CPUSockets}},
             @{n='Total CPU Cores';e={$_.CPUCores}},
             @{n='Virtual';e={$_.IsVirtual}},
             @{n='Virtual Type';e={$_.VirtualType}},
             @{n='Total Physical RAM';e={$_.PhysicalMemoryTotal}},
             @{n='Free Physical RAM';e={$_.PhysicalMemoryFree}},
             @{n='Total Virtual RAM';e={$_.VirtualMemoryTotal}},
             @{n='Free Virtual RAM';e={$_.VirtualMemoryFree}},
             @{n='Total Memory Slots';e={$_.MemorySlotsTotal}},
             @{n='Memory Slots Utilized';e={$_.MemorySlotsUsed}},
             @{n='Uptime';e={$_.Uptime}},
             @{n='Install Date';e={$_.InstallDate}},
             @{n='Last Boot';e={$_.LastBootTime}},
             @{n='System Time';e={$_.SystemTime}}
        }
    }
    'Disk' = @{
       'Enabled' = $true
       'AllowEmptyReport' = $true
       ....</pre>

With a structure like this I then can take the same section and re-purpose the data to suit several different reports pretty easily. This also provides a very fast way to change a property name in the report output, add a property to any report, or remove them as well. You simply need a section name to reference as well as your report type.

As long as I load the data to a holding area first I can easily process each property of the data on the fly with this structure like so (note that $AvailableReports is my &#8220;holding area&#8221;, it contains yet another hash called &#8216;AllData&#8217; where all the asset data is referenced by asset names as the hash key)

<pre class="lang:powershell decode:true ">$ReportElementSource = $AvailableReports[$Section]['AllData'][$Asset]
$SourceProperties = $ReportOptions[$Section]['ReportProperties'][$ReportType]
Foreach ($TableElement in $ReportElementSource)
{
    $AllTableElements += $TableElement | Select $SourceProperties
}</pre>

[The whole script][1] in all its horrible glory can be found in one huge ps1 file at the technet gallery. While there is still a ways to go towards getting this to a state I&#8217;m happy with I&#8217;d say it is a good start.

 [1]: https://gallery.technet.microsoft.com/Excel-and-HTML-Asset-0ffbf569
 [2]: https://gallery.technet.microsoft.com/Active-Directory-Audit-7754a877
 [3]: https://gallery.technet.microsoft.com/Big-IP-F5-LTM-Load-3fc9a2af
 [4]: https://gallery.technet.microsoft.com/Lync-2013-Mirrored-SQL-132c2f06
 [5]: http://gallery.technet.microsoft.com/Get-GeneralSystemReportps1-4d9b5817
 [6]: /2013/08/05/multithreaded-system-asset-gathering-with-powershell/
 [7]: /2013/08/06/multithreaded-remote-registry-gathering-with-powershell/
 [8]: http://gallery.technet.microsoft.com/Create-HTML-Bar-Graph-63cff29d
 [9]: http://www.responsivegridsystem.com/