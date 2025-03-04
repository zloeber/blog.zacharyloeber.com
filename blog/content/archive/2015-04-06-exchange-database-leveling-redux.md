---
title: 'Exchange: Database Leveling Redux'
author: Zachary Loeber
type: post
date: 2015-04-07T00:12:33+00:00
url: /blog/2015/04/06/exchange-database-leveling-redux/
categories:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - PSC
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
Some time ago I [tackled the challenge][1] of constructing a variant of the bin packing algorithm for leveling out Exchange databases&#8217; size with the least amount of mailbox migrations necessary. Since then, I&#8217;ve been approached by a few people in dreadfully large environments looking for help with errors and compatibility issues around the script I released. I&#8217;ve finally rounded back to this script to do it some justice.

<!--more-->

This was one of those scripts I initially put together as an intellectual exercise so I could stop thinking about it. I worked rather hard in late night hours logically constructing the process of what needed to be done for the algorithm. Once I got working results and a decent write up performed I breathed a sigh of relief that I could be free of the mental obsession and didn&#8217;t even look back at the quality of the script. This simultaneously made this one of the works I&#8217;ve been most proud and ashamed of.

There were a number of issues with the script I&#8217;ve either always known or have been made aware by others in the last year. Some of the notable ones are:

  1. Inability to run in Exchange 2010 environments
  2. Needing to be run directly in an Exchange session (thus possibly over utilizing resources)
  3. No calculation of disconnected mailboxes in database size
  4. Overall script complexity making it difficult to approach for many who might want to use it in their environment
  5. Some environments exhibited strange errors while processing mailboxes/databases

As with most of my work, I made a mental note to come back to it and re-release with some fixes should no other kind-hearted Powershell scripter decide to do so themselves. Of course no one has so here I am working on this thing yet again 🙂

To address the complexity (issue #4) I&#8217;ve wrapped the entire script with some parameters. You can still fine tune variables directly in the script but to keep things light and easy (and force a bit of usage rules) I&#8217;m only going to have two flags, SaveData and LoadData. Coincidentally, this will address points one and two as well. I&#8217;ve decided to divorce the information gathering portion from the processing portion of the script. I believe that issues with running the script I wrote in an exchange 2010 environment is largely due to the powershell version differences.

So for those running into pipeline errors and other such nonsense when running this script, please attempt to run this updated script with the -ExportData flag on your server, copy over the ExchangeData.csv file to your workstation (in the same folder as the script), then run the same script with the -ImportData flag. Optionally you can use the -verbose flag to see some more details fly by the screen.

For issue #5 I was not able to really zero in on a specific cause but in performing a code review I found that I was doing a few things that may lead to issues in specific environments. One such thing was not properly escaping strings for regular expression matching. So I was doing this:

<pre class="lang:powershell decode:true">$_.Name -match ($IGNORED_MAILBOXES -join '|')</pre>

<span style="line-height: 1.6;">When I should have been doing this:</span>

<pre class="lang:powershell decode:true">$IGNORED_DATABASES = @()
$ESC_IGNORED_DATABASES = @($IGNORED_DATABASES | Foreach {[regex]::Escape($_)})

$_.Name -match ($ESC_IGNORED_DATABASES -join '|')</pre>

Oh, and if you pay close attention to that last line you can find a pretty big mistake. What if there are no ignored databases? If $IGNORED_MAILBOXES = @() then this line will always match! So to be correct we need to make a regular expression that is positionally correct as well:

<pre class="lang:powershell decode:true">$_.Name -match ('^(' + ($ESC_IGNORED_DATABASES -join '|') + ')$')
</pre>

I also found some bizarre constructs I put together that I&#8217;d normally never release. For instance here I try to get all the unique databases but first select the property of the objects then try to filter them:

<pre class="lang:powershell decode:true">$DBSet = @(($Mailboxes | select Database -Unique | Where {$_.Database -notmatch [regex]::Escape($IGNORED_DATABASES -join '|')}).Database)</pre>

But  it makes more sense and is slightly less cumbersome to filter first then get the property. Actually, how about I filter at the mailbox information gathering portion and reduce that long line down to this instead?

<pre class="lang:powershell decode:true">$DBSet = @(($Mailboxes).Database | Select -Unique)</pre>

While that works on severs and workstations which default to newer versions of powershell but if you run that on a windows 2008 R2 server you will likely see that $DBSet ends up with a $null value. So I finally had to land on using the following instead (slightly less ugly than the original but irritatingly long winded compared to the last line though):

<pre class="lang:powershell decode:true">$DBSet = @($Mailboxes | Select Database -unique | Foreach {$_.Database})</pre>

These are just a few of the fixes I made in my code review. I also improved processing speeds a bit by reducing the overall number of mailboxes in the total processing set, improved output to page through long results, and cleaned out unused code among other things.

## Download

I&#8217;ve uploaded the script within [the Microsoft Technet Gallary][2] and have uploaded a copy [to my Github repo][3] as well.

## Note

If you really want to know the general idea and logic of the algorithm behind the script [read my prior article on the matter][1]. I go as far as to use some equations and even some diagrams in the write up and I consider it all very well thought out from an academic standpoint (at least no one has said otherwise).

I hope to get some feedback around this from you if you do end up using it. People reaching out to me with suggestions and stories of how they use my work in their environments is part of what keeps me releasing new and useful tools.

 [1]: /2014/01/07/exchange-20102013-database-leveling-script/
 [2]: https://gallery.technet.microsoft.com/Leveling-Exchange-Database-3e9cdbc9
 [3]: https://github.com/zloeber/Powershell/blob/master/Exchange/New-ExchangeRebalancingReport.ps1