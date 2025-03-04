---
title: 'Powershell Tip: Convert HTML to PDF'
author: Zachary Loeber
type: post
date: 2014-03-07T18:55:35+00:00
excerpt: There are no native methods to create a pdf file in Powershell. So I looked into outside sources for converting HTML output to PDF. I ended up using a stand alone dll and some .NET calls to achieve my goal.
url: /blog/2014/03/07/posh-tip-convert-html-to-pdf/
categories:
  - Microsoft
  - Powershell
tags:
  - Powershell
  - PSC
  - Scripting

---
There are no native methods to create a pdf file in Powershell. So I looked into outside sources for converting HTML output to PDF. I ended up using a stand alone dll and some .NET calls to achieve my goal.

<!--more-->

### Introduction

Honestly I forgot why I thought it would be important that my report generation scripts be able to create pdf output. I had a fun time figuring out how to make it happen though. I settled on using [a third party dll][1] from codeplex (supposedly codeplex.com is all about open source projects but I’ve yet to see the source for several of the cooler projects hosted here). While watching a movie with the wife I proceeded to work my way backwards from a VB example to come up with a Powershell alternative. This is how it works.

### Details

Here is the singular example given for this dll:

> Generate PDF with one line of code:
> 
> <pre>var pdfBytes = (new NReco.HtmlToPdfConverter()).GeneratePdf(htmlContent);</pre>

The code seems simple enough, feed the GeneratePdf object member some html and a pdf will get created like magic. The minor challenge is taking this .Net based dll, loading it into memory, defining the correct object from its assemblies, and feeding it the properly formatted html data so that it can create a pdf.

First lets define the dll location (which we test actually exists in a full blown function provided later):

<pre>$PdfGenerator = "$((Get-Location).Path)\NReco.PdfGenerator.dll"</pre>

Next lets load up the assembly and create a new NReco.HtmlToPdfConverter object to work with:

<pre>$Assembly = [Reflection.Assembly]::LoadFrom($PdfGenerator)
 $PdfCreator = New-Object NReco.PdfGenerator.HtmlToPdfConverter</pre>

Finally, use the GeneratePdf method to create a pdf which we then write to a file in byte mode (pdf output is not simple text after all)

<pre>$ReportOutput = $PdfCreator.GeneratePdf([string]$HTML)
Add-Content -Value $ReportOutput -Encoding byte -Path $FileName</pre>

You will notice that I explicitly cast the $html to a string. With the function I provide you will have to send the html data cast this way. I found that if I pulled in html content from a file it would result in an array of strings which the GeneratePdf method would treat individually. This would end up creating 100+ page pdf pages (a page for every element).

If you play around with $PdfCreator you will find that there are several methods included for changing page size and other document properties as well.

### The Code

Here is the function I came up with to convert html to a pdf. Included at the end is a quick example. If you are going to use this code then you will likely have to unblock the dll after extracting it into the same directory as the script. Also, I had to run PowerGUI as admin otherwise I didn’t have enough permission to load the dll into memory. Enjoy!

<pre class="lang:powershell decode:true">Function ConvertTo-PDF
{
    &lt;#
    .SYNOPSIS
        Converts HTML strings to pdf files.
    .DESCRIPTION
        Converts HTML strings to pdf files.
    .PARAMETER HTML
        HTML to convert to pdf format.
    .PARAMETER ReportName
        File name to create as a pdf.

    .EXAMPLE
        $html = 'test'
        try 
        {
            ConvertTo-PDF -HTML $html -FileName 'test.pdf' #-ErrorAction SilentlyContinue) 
            Write-Output 'HTML converted to PDF file test.pdf'
        } 
        catch
        {
            Write-Output 'Something bad happened! :('
        }

        Description:
        ------------------
        Create a pdf file with the content of 'test' if the pdf creation dll is available.

    .NOTES
        Requires   : NReco.PdfGenerator.dll (http://pdfgenerator.codeplex.com/)
        Version    : 1.0 03/07/2014
                     - Initial release
        Author     : Zachary Loeber

        Disclaimer : This script is provided AS IS without warranty of any kind. I 
                     disclaim all implied warranties including, without limitation,
                     any implied warranties of merchantability or of fitness for a 
                     particular purpose. The entire risk arising out of the use or
                     performance of the sample scripts and documentation remains
                     with you. In no event shall I be liable for any damages 
                     whatsoever (including, without limitation, damages for loss of 
                     business profits, business interruption, loss of business 
                     information, or other pecuniary loss) arising out of the use of or 
                     inability to use the script or documentation. 

        Copyright  : I believe in sharing knowledge, so this script and its use is 
                     subject to : http://creativecommons.org/licenses/by-sa/3.0/
    .LINK
        http://zacharyloeber.com/

    .LINK
        http://nl.linkedin.com/in/zloeber
    #&gt;
    [CmdletBinding()]
    param
    (
        [Parameter( HelpMessage="Report body, in HTML format.", 
                    ValueFromPipeline=$true )]
        [string]
        $HTML,
        [Parameter( HelpMessage="Report filename to create." )]
        [string]
        $FileName
    )
    BEGIN
    {
        $DllLoaded = $false
        $PdfGenerator = "$((Get-Location).Path)\NReco.PdfGenerator.dll"
        if (Test-Path $PdfGenerator)
        {
            try
            {
                $Assembly = [Reflection.Assembly]::LoadFrom($PdfGenerator)
                $PdfCreator = New-Object NReco.PdfGenerator.HtmlToPdfConverter
                $DllLoaded = $true
            }
            catch
            {
                Write-Error ('ConvertTo-PDF: Issue loading or using NReco.PdfGenerator.dll: {0}' -f $_.Exception.Message)
            }
        }
        else
        {
            Write-Error ('ConvertTo-PDF: NReco.PdfGenerator.dll was not found.')
        }
    }
    PROCESS
    {
        if ($DllLoaded)
        {
            $ReportOutput = $PdfCreator.GeneratePdf([string]$HTML)
            Add-Content -Value $ReportOutput -Encoding byte -Path $FileName
        }
        else
        {
            Throw 'Error Occurred'
        }
    }
    END
    {}
}

$html = 'test'
try 
{
    ConvertTo-PDF -HTML $html -FileName 'test.pdf' #-ErrorAction SilentlyContinue) 
    Write-Output 'HTML converted to PDF file test.pdf'
} 
catch
{
    Write-Output 'Something bad happened! :('
}</pre>

 [1]: http://pdfgenerator.codeplex.com/