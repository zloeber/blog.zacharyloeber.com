---
title: 'Powershell: Get-iQuote'
author: Zachary Loeber
type: post
date: 2015-02-08T15:46:49+00:00
excerpt: While scratching an itch I found a cool little site that has a simple to use REST api for returning random quotes from multiple categories. Here is a small function which utilizes this online source to pull quotes from the web!
url: /blog/2015/02/08/powershell-get-iquote/
categories:
  - Microsoft
  - Powershell
tags:
  - Powershell
  - Powershell Script
  - PSC

---
While scratching an itch I found a cool little site that has a simple to use REST api for returning random quotes from multiple categories. Here is a small function which utilizes this online source to pull quotes from the web!

<!--more-->

I must have hundreds of these one off scripts laying around in my personal repository collecting dust. I’m trying to get more of these out there as examples (either good or bad!) for others to use in their scripting endeavors. This one is just for fun but has some good examples of; ValidateScript parameter validation, Invoke-WebRequest, Regular Expressions.

<pre class="lang:powershell decode:true">function Get-iQuote {
    &lt;#
    #Valid Sources
    #From geek: esr humorix_misc humorix_stories joel_on_software macintosh math mav_flame osp_rules paul_graham prog_style subversion
    #From general: 1811_dictionary_of_the_vulgar_tongue codehappy fortune liberty literature misc murphy oneliners riddles rkba shlomif shlomif_fav stephen_wright
    #From pop: calvin forrestgump friends futurama holygrail powerpuff simon_garfunkel simpsons_cbg simpsons_chalkboard simpsons_homer simpsons_ralph south_park starwars xfiles
    #From religious: bible contentions osho
    #From scifi: cryptonomicon discworld dune hitchhiker
    
    # Example
    Get-iQuote -max_lines 2 -source @('esr','math')
    #&gt;

    param (
        [Parameter(Position=0,HelpMessage='return format of quote')]
        [ValidateSet('text','html','json')]
        [string]$format = 'text',
        [Parameter(Position=1,HelpMessage='Maximum number of lines to return')]
        [int]$max_lines,
        [Parameter(Position=2,HelpMessage='Minimum number of lines to return')]
        [int]$min_lines,
        [Parameter(Position=3,HelpMessage='Maximum number of characters to return')]
        [int]$max_characters,
        [Parameter(Position=4,HelpMessage='Minimum number of characters to return')]
        [int]$min_characters,
        [Parameter(Position=5,HelpMessage='One or more quote categories to query.')]
        [ValidateScript({
            $validsources = @('esr','humorix_misc','humorix_stories','joel_on_software','macintosh','math','mav_flame','osp_rules','paul_graham','prog_style','subversion','1811_dictionary_of_the_vulgar_tongue','codehappy','fortune','liberty','literature','misc','murphy','oneliners','riddles','rkba','shlomif','shlomif_fav','stephen_wright','calvin','forrestgump','friends','futurama','holygrail','powerpuff','simon_garfunkel','simpsons_cbg','simpsons_chalkboard','simpsons_homer','simpsons_ralph','south_park','starwars','xfiles','bible','contentions','osho','cryptonomicon','discworld','dune','hitchhiker')
            if ((Compare-Object -ReferenceObject $validsources -DifferenceObject $_).SideIndicator -contains '=&gt;') {
                $false
            }
            else {
                $true
            }
        })]
        [string[]]$source = @('esr','humorix_misc','humorix_stories','joel_on_software','macintosh','math','mav_flame','osp_rules','paul_graham','prog_style','subversion','1811_dictionary_of_the_vulgar_tongue','codehappy','fortune','liberty','literature','misc','murphy','oneliners','riddles','rkba','shlomif','shlomif_fav','stephen_wright','calvin','forrestgump','friends','futurama','holygrail','powerpuff','simon_garfunkel','simpsons_cbg','simpsons_chalkboard','simpsons_homer','simpsons_ralph','south_park','starwars','xfiles','bible','contentions','osho','cryptonomicon','discworld','dune','hitchhiker')
    )
    $req_uri = 'http://www.iheartquotes.com/api/v1/random?format=' + $format 
    $PSBoundParameters.Keys | Foreach {
        if ($_ -ne 'format') {
            $paramval = 
            $req_uri += '&' + $_ + '=' + ($PSBoundParameters[$_] -join '+')
        }
    }

    $sources = ($source | % { [regex]::escape($_) } ) -join '|'
    $sourceregex = '(?m)^([^\[]*)(?:\[(' + $sources + ')\].+)$'
    
    $quote = (Invoke-WebRequest -Uri $req_uri).content

    ((([regex]::Match($quote,$sourceregex)).Groups)[1]).Value -replace '"','"'
}</pre>

One of the more interesting items about this script is that the parameters are actually named exactly as the parameters used in the web request. So all I have to do is parse through the parameters which were passed to the function by key name to build up the web request. This dramatically decreases the overall function size and is a semi-clever hack if I do say so myself.

Keep on scripting my friends!