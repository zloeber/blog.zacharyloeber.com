---
title: 'Powershell: Make Pretty Scripts..With Scripts'
author: Zachary Loeber
type: post
date: 2015-10-15T17:58:07+00:00
url: /blog/2015/10/15/powershell-make-pretty-scripts-with-scripts/
categories:
  - Microsoft
  - Powershell
tags:
  - Powershell
  - Powershell Script
  - Scripting
  - Windows

---
I released a new module for standardizing and beautifying your PowerShell code. Aside from code indentation it also can reduce line length, replace here-strings, and a whole lot more.

<!--more-->

# Introduction

Some people sit down after a long day&#8217;s work, turn on the TV, and proceed to do suduku or crossword puzzles to wind down. I sit down and marathon watch old star trek series with the wife and hack through coding algorithms or puzzles that I cannot get out of my head. This module is the result of &#8216;just one more&#8217; puzzle after another on the quest to automatically reformat some of my old PowerShell projects in an automated manner. I&#8217;ve taken it far enough along that I think it may be worth publicizing a little bit to see if I&#8217;m on the right path or if I need to simply stop obsessing over AST, tokens, and code formatting functions.

So what I&#8217;ve done is create a PowerShell module and it is creatively called&#8230;.

# Format PowerShell Code Module

This is a set of functions to re-factor your script code in different ways with the aim of beautifying and standardizing your code.

  1. This module has multiple goals. Here are a few things one might use it for:
  2. Cleanse and format code copied from the web (fix characters)
  3. Refactor your old code to adhere to best practices in line length, alias usage, type definition usage, indentation and so on.
  4. Use as a pre-build tool to maintain consistency across your code base.
  5. Turn someone else&#8217;s insane semi-colon riddled one liner into a script that doesn&#8217;t hurt your eyes quite as much.

My selfish reasons for this project were primarily to fix up my old code though. I&#8217;ve got tens of thousands of lines of code I want to add features too and improve upon but everytime I open it up one of these old scripts I find myself tediously editing the code for style and other waste of time changes which should be automatic.

## Limitations

What this module is not going to do is fix broken PowerShell! Much of exported cmdlets use AST which can only parse functioning code (with some interesting exceptions).

## Stupid Cmdlet Names

Well I think they are kind of silly at least. To keep the cmdlets in this code distinct I&#8217;ve gone with the following rather non-standard naming standard:

Format-Script_**WhatTheFormattingDoes**_

It feels a bit wonky but we can always change it later I suppose&#8230;.

## Warnings

I really don&#8217;t think this should need to be stated but here it is anyway&#8230;

Do **NOT** just read in your source code and blindly pipe it to the cmdlets included in this module and then write the results out to the same file! I&#8217;ve tried to account for a large number of caveats and scenarios but I&#8217;m positive I&#8217;ve not thought of them all. Additionally I&#8217;ve written this code primarily for myself (hey, we are all selfish creatures). What seems to work fine for me may not work at all for your code.

Even though every function defaults to validating the script text after processing I&#8217;d go as far as to say you should unit test your code before and after any reformatting done by this module to ensure you get consistent results.

Consider yourself warned.

## Logic

Each formatting function has its own special logic. Generally though we tend to perform the actual string manipulations (script formatting) working from the bottom up. Working in reverse lets us not have to refactor token/string locations after every change made. This is especially true of token driven updates like tabifying your script with Format-ScriptFormatCodeIndentation.

There are many interesting exceptions I&#8217;ve run into which required some elegant and not so elegant methods to work around. In these cases I try to note in comments where I think more elegant code or algorithms could have been used (which I simply was unable to figure out). A good example is NamedBlockAST or StatementBlockAST code expansion. As there can be embedded blocks beneath each block you find you cannot simply make a change without all the extent start and end locations for every AST element below it changing. So I recreate the AST search results on every iteration for every change made. It feels&#8230; awkward but I&#8217;ve no better solution yet.

> **NOTE:** None of the functions in this module touch comments! I&#8217;ve no way to tell what you are intending with your comments so we do our very best to simply leave them alone. This doesn&#8217;t mean that I&#8217;ve tested every variant of comments existing in oddball places in your code so I&#8217;ll repeat that you should proceed with caution!

## Usage

Each function included with this module can be used individually but many of these functions were built around one another for specific purposes. Simply piping all your code through all the cmdlets exported in this module is likely to make your code even more grotesque looking than it was beforehand. Here are a few example usages which you may find handy.

> **NOTE:** Most functions which affect newlines in any manner (expanding code blocks, removing semicolons, et cetera) do nothing for your indentation. This was done on purpose to keep each function as basic as possible. This means you will almost always run your code through Format-ScriptFormatCodeIndentation at the very end of any transformations you are performing!

### Example 1 &#8211; Condense and Remove &#8216;Here Strings&#8217;

[Here-strings][1] are pretty useful variable assignments which are essentially multi-lined strings. I&#8217;ve used them for embedding quick templates into my code among other things. They are also totally unwieldy when it comes to making your code look nice. This is because they have strict requirements as to where the terminating here string characters must be (the start of the next line in column 0). Here is an example function with a here string assignment embedded within:

<pre class="lang:powershell decode:true ">function New-CPUReport ($Title,$Data) {
    $Report = @"

-----------------------------------------------------
- $($Title)
-----------------------------------------------------
Process ID		Process Name		CPU Usage

"@

$ReportDataTemplate = @'
&lt;&gt;			&lt;&gt;			&lt;&gt;

'@
    $Data | Foreach {
        $Report += $ReportDataTemplate -replace '&lt;&gt;',$_.ID -replace '&lt;&gt;',$_.Name -replace '&lt;&gt;',$_.CPU
    }
    
    return $Report
}

$Data = Get-Process | Sort-Object -Property CPU -Descending | select -First 5
New-CPUReport 'My Rocking Report!' $Data</pre>

The here-strings are embedded in a function and are thusly unable to be indented without breaking the script entirely. Here is what we would like to happen to fix this:

  1. Convert here strings into simple multiple part string assignments
  2. As these string assignments will likely be very long we would also like to automatically reduce the line length of the script by automatically inserting line breaks in appropriate positions.
  3. Automatically indent the resulting code.

To achieve these tasks with this module you would simply do the following:

<pre class="lang:powershell decode:true ">import-module .\FormatPowershellCode.psm1
Get-Content .\tests\testcase-strings.ps1 -raw | 
    Format-ScriptReplaceHereStrings |
    Format-ScriptReduceLineLength |
    Format-ScriptFormatCodeIndentation | 
    clip</pre>

The resulting code would look a bit less unsightly (though not by much as it was a fast and dumb example to begin with):

<pre class="lang:powershell decode:true ">function New-CPUReport ($Title,$Data) {
    $Report = "-----------------------------------------------------" +
    "`r`n" + "- $($Title)" + "`r`n" +
    "-----------------------------------------------------" + "`r`n" +
    "Process ID		Process Name		CPU Usage" + "`r`n"
    
    $ReportDataTemplate = '&lt;&gt;			&lt;&gt;			&lt;&gt;' + "`r`n"
    $ReportFooter = '-----------------------------------------------------' + "`r`n"
    $Data | Foreach {
        $Report += $ReportDataTemplate -replace '&lt;&gt;',$_.ID -replace '&lt;&gt;',$_.Name -replace '&lt;&gt;',$_.CPU
    }
    
    
    $Report += $ReportFooter                
    
    return $Report      
}

$Data = Get-Process | Sort-Object -Property CPU -Descending | select -First 5
New-CPUReport 'My Rocking Report!' $Data</pre>

### Example 2 &#8211; De-obfuscation

A truly obfuscated bit of PowerShell code will require more than this module to de-obfuscate but this module may help a little bit in making it more readable. You may &#8216;de-obfuscate&#8217; a crazy looking one-liner you came up with to just get a job done in the heat of the moment. Here is a one-liner I purposefully made look like crap. It is a function that gets the lines of a script that token kinds are found between:

<pre class="lang:powershell decode:true ">function Format-ScriptGetKindLines {[CmdletBinding()]param([parameter(Position=0, ValueFromPipeline=$true, HelpMessage='Lines of code to process.')][string[]]$Code,[parameter(Position=1, HelpMessage='Type of AST kind to retrieve.')][string]$Kind = "*"); begin {$Codeblock = @();$ParseError = $null; $Tokens = $null; $FunctionName = $MyInvocation.MyCommand.Name; Write-Verbose "$($FunctionName): Begin."}; process{$Codeblock += $Code }; end { $ScriptText = $Codeblock | Out-String;  Write-Verbose "$($FunctionName): Attempting to parse AST."; $AST = [System.Management.Automation.Language.Parser]::ParseInput($ScriptText, [ref]$Tokens, [ref]$ParseError);  if($ParseError) { $ParseError | Write-Error; throw "$($FunctionName): Will not work properly with errors in the script, please modify based on the above errors and retry." }; $TokenKinds = @($Tokens | Where {$_.Kind -like $Kind}); Foreach ($Token in $TokenKinds) { New-Object psobject -Property @{ 'Start' = $Token.Extent.StartLineNumber; 'End' = $Token.Extent.EndLineNumber;}}; Write-Verbose "$($FunctionName): End." }}</pre>

In order to make this look more like a version which doesn&#8217;t instantly give you a migraine you&#8217;d need to perform several transformations. Here is the general logic of what we will do:

  1. Turn statement separators (semicolons) into newlines
  2. Expand function blocks (function{})
  3. Expand named blocks (begin/process/end)
  4. Expand parameter blocks (param())
  5. Expand statement blocks (if/then/else)
  6. Move starting curly braces to the end of the prior line (a personal preference)
  7. Auto-indent all blocks with 4 spaces

With this module you would accomplish this with the following:

<pre class="lang:powershell decode:true">import-module .\FormatPowershellCode.psm1
get-content .\tests\testcase-codeblockexpansion.ps1 -raw |
    Format-ScriptRemoveStatementSeparators |
    Format-ScriptExpandFunctionBlocks |
    Format-ScriptExpandNamedBlocks |
    Format-ScriptExpandParameterBlocks |
    Format-ScriptExpandStatementBlocks |
    Format-ScriptFormatCodeIndentation |
    Format-ScriptCondenseEnclosures |
    clip</pre>

Then you can go ahead and paste the output into your favorite editor to get something more palatable:

<pre class="lang:powershell decode:true">Format-ScriptGetKindLines {
    [CmdletBinding()]
    param (
    [parameter(Position=0, ValueFromPipeline=$true, HelpMessage='Lines of code to process.')]
    [String[]]$Code,
    [parameter(Position=1, HelpMessage='Type of AST kind to retrieve.')]
    [String]$Kind
    )
    
    Begin {
        $Codeblock = @()
        $ParseError = $null
        $Tokens = $null
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."
    }
    Process {
        $Codeblock += $Code
    }
    End {
        $ScriptText = $Codeblock | Out-String
        Write-Verbose "$($FunctionName): Attempting to parse AST."
        $AST = [System.Management.Automation.Language.Parser]::ParseInput($ScriptText, [ref]$Tokens, [ref]$ParseError)
        if($ParseError)  {
            $ParseError | Write-Error
            throw "$($FunctionName): Will not work properly with errors in the script, please modify based on the above errors and retry."
        }
        $TokenKinds = @($Tokens | Where {$_.Kind -like $Kind})
        Foreach ($Token in $TokenKinds)  {
            New-Object psobject -Property @{ 'Start' = $Token.Extent.StartLineNumber
                'End' = $Token.Extent.EndLineNumber
            }
        }
        Write-Verbose "$($FunctionName): End."
    }
}</pre>

> **NOTE**: I&#8217;ve included a vanity function you can tack on the end of any transform to move the beginning curly brace to the end of the prior line called  Format-ScriptCondenseEnclosures. I prefer my code with less wasted lines but its just a personal preference so the default for all expansion transforms is to place the start of blocks ({) on their own line.

&nbsp;

# Included Functions

Thus far I&#8217;ve completed and done testing with the following exported module members:

[table id=1 /]

# Conclusion

Well this was a long post but I&#8217;m releasing a fairly large module to to community so it was probably warranted. If you find some time to take this module and kick its tires I&#8217;d love input and community involvement. You can install the module like so:

<pre class="lang:powershell decode:true ">iex (New-Object Net.WebClient).DownloadString("https://github.com/zloeber/FormatPowershellCode/raw/master/Install.ps1")</pre>

Otherwise with PowerShell 5 you can simply install from the gallery with the following:

<pre class="lang:powershell decode:true">Install-Module FormatPowershellCode</pre>

Or manually download/clone/fork the project at Github: <https://github.com/zloeber/FormatPowershellCode>

 [1]: https://technet.microsoft.com/en-us/library/ee692792.aspx