---
title: 'Powershell: Colorize-Table Function'
author: Zachary Loeber
type: post
date: 2013-04-18T03:03:36+00:00
url: /blog/2013/04/17/powershell-colorize-table-function/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - network administration
  - Powershell
  - Reporting
  - Scripting
  - System Administration

---
Here is a function I modified for quickly modifying the attributes of a table&#8217;s rows or individual cells. It uses Linq and is blistering fast. The results are pretty as well so that doesn&#8217;t hurt either.

<!--more-->

[Here is the script on the Technet Gallery][1]

Here is an example which produces a semi-useful example report of the top memory consuming processes.  Anything taking over 150 Mb is highlighted yellow. Above 400 Mb gets highlighted red. The order for processing the table is obviously important, so they don’t all end up the same color. For this example we highlight the entire row but the individual cells can just as easily be color coded with this function (or styled or whatever fits your fancy actually).

By default the table is boring. This custom header is used to add some borders and such.

<pre>$TableStyle = @'</pre>

<pre>&lt;title&gt;Process Report&lt;/title&gt;</pre>

<pre>      &lt;style&gt;</pre>

<pre>      BODY{font-family: Arial; font-size: 8pt;}</pre>

<pre>      H1{font-size: 16px;}</pre>

<pre>      H2{font-size: 14px;}</pre>

<pre>      H3{font-size: 12px;}</pre>

<pre>      TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}</pre>

<pre>      TH{border: 1px solid black; background: #dddddd; padding: 5px; color: #000000;}</pre>

<pre>      TD{border: 1px solid black; padding: 5px;}</pre>

<pre>      &lt;/style&gt;</pre>

<pre>'@</pre>

Now gather all processes, include the name, company, and Memory. Rename WS to Memory for readability, truncate, and convert to Mb. then sort in reverse order and return the top 5 results.

<pre>$tabletocolorize = $(<b>get-process</b> | <b>select</b> <i>-Property</i> ProcessName,Company,@{Name="Memory";Expression={[math]::truncate($_.WS/ 1Mb)}} | <b>Sort-Object</b> Memory <i>-Descending</i> | <b>Select</b> <i>-First</i> 5 )</pre>

This scriptblock is passed directly into the function, the variable names are important and should not change as they are used in the function (because I wasn’t able to get abstraction to work properly for whatever reason). If you really like you can replace [int]$args[1] with some static number or string and the ColumnValue parameter will be ignored when passed to the function. I also found it was important to use strong typesetting in the script block. If you don’t need anything fancy and just want to change a cell/row based on what value is in it then don’t pass any scriptblock and a general equal comparison will be performed on ColumnValue which you will have to pass instead.

<pre>[scriptblock]$scriptblock = {[int]$args[0] -gt [int]$args[1]}</pre>

Run the first passthrough for any columns with the Memory value above 150 to highlight the row yellow. This is the first time through so I tack on the HTMLHead.

<pre>$testreport = Colorize-Table $tabletocolorize <i>-Column</i> "Memory" <i>-ColumnValue</i> 150 <i>-Attr</i> "style" <i>-AttrValue</i> "background:yellow;" <i>-ScriptBlock</i> $ScriptBlock <i>-HTMLHead</i> $TableStyle <i>-WholeRow</i> $true</pre>

Then run again for the same row for any items above 400 to highlight the row red.

<pre>$testreport = Colorize-Table $testreport <i>-Column</i> "Memory" <i>-ColumnValue</i> 400 <i>-Attr</i> "style" <i>-AttrValue</i> "background:red;" <i>-ScriptBlock</i> $ScriptBlock <i>-WholeRow</i> $true</pre>

Spit out the report to a file and open it up.

<pre>$testreport | <b>Out-File</b> "$pwd/testreport.html"</pre>

<pre><b>ii</b> "$pwd/testreport.html"</pre>

The resulting table

[<img class="aligncenter size-full wp-image-759" alt="ColoredTable-Process_Report" src="/wp-content/uploads/2013/04/ColoredTable-Process_Report.jpg?resize=249%2C143" width="249" height="143" data-recalc-dims="1" />][2]

 [1]: http://gallery.technet.microsoft.com/Colorize-HTML-Table-Cells-2ea63acd "Powershell Colorize-Table Function on Technet gallery"
 [2]: /wp-content/uploads/2013/04/ColoredTable-Process_Report.jpg