---
title: 'Powershell: Word/Excel Helper Functions'
author: Zachary Loeber
type: post
date: 2014-03-17T03:19:39+00:00
excerpt: Using powershell I wrap up MS Word and Excel COM objects within a custom psobject. This object contains a handful of methods for making docx and xslx creation and manipulation easier.
url: /blog/2014/03/16/powershell-wordexcel-helper-functions/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Powershell
  - PSC
  - Reporting
  - Scripting

---
Using powershell I wrap up MS Word and Excel COM objects within a custom psobject. This object contains a handful of methods for making docx and xslx creation and manipulation easier.

<!--more-->

#### Introduction

I typically don’t generate many Excel or Word documents programmatically. I find the process involved to be cumbersome due to the many nuances and intricacies of the COM objects which make up the API to the Office products. I also prefer html as it is a bit more universal, can easily be saved to an IIS directory for custom portals, and can be [converted to PDF easily enough][1]. But everyone likes Word/Excel so much that I finally bit the bullet and looked into what it would take to deal with generating reports for these apps on my terms.

#### Details

Most of the examples I came across for Word (or Excel) document generation used $global: or $script: scoping to modify the documents in custom functions. This made the functions very script dependent and hard to reuse. To get around this limitation I encapsulate several essential functions as script methods on a custom object which represents the document you are generating.

Using script methods as properties on a psobject in order to to make a self-contained uber-object is not always the right way to go. In fact, I don’t know that this technique should ever be used in powershell as it starts to blend into the world of OOP programming (my roots from oh so long ago…) and is not very self documenting. But, right or wrong, it works for me so it may work for you as well.

A caveat to doing it this way is that you need to call the script methods in a non-standard manner (at least for powershell). Here is an example of some of the resulting code. Note how functions are called as if you are calling COM methods. This is a bit apropos as all we are doing is wrapping some code around COM object instances.

<pre class="lang:powershell decode:true" title="Word Example">##### Example Code #####
$testdata = Get-Process | 
             Select-Object Handle,ID,Name,@{'n'='TrueProperty';e={$true}},@{'n'='FalseProperty';e={$false}} | 
             Select-Object -first 20
try
{
    # Word test. Create and then save and close a new document with a few tables, a table of contents, and 
    #  cover page.
    $word = New-WordDocument -Visible $false
    $word.NewCoverPage()
    $word.NewBlankPage(1)
    $word.MoveToEnd()
    $word.NewPageBreak()
    $word.NewHeading('Section 1')
    $word.NewText('Just testing out if this works...')
    $word.NewTable(4,10) | Out-Null
    $word.MoveToEnd()
    $word.NewPageBreak()
    $word.NewHeading('Section 2')
    $testtable = $word.NewTableFromArray($testdata) # | Out-Null
    $word.NewTOC()
    $word.SaveAs('c:\Temp\testdoc.docx')
    $word.CloseDocument()
    Remove-Variable word
}
catch
{
    Write-Error "Issue creating word document"
}</pre>

Here is another example using the same data from the prior example to create a multiple worksheet excel workbook.

<pre class="lang:powershell decode:true">try
{
    # Excel test. Create and then save and close a new workbook.
    $excel = New-ExcelWorkbook -Visible $false
    $excel.NewWorksheetFromArray($testdata,'Processes')
    $excel.NewWorksheetFromArray($testdata,'Duplicate of Processes')
    $excel.SaveAs('c:\temp\testexcel.xlsx')
    $excel.CloseWorkbook()
    Remove-Variable excel
}
catch
{
    Write-Error "Issue creating excel document"
}</pre>

I&#8217;ve setup the actual wrapper functions with a handful of the most important methods to suit my needs. Mostly they are just for inserting tables, moving around the document, and some other general tasks. I didn&#8217;t go overboard as really most of the features you would need to use can be called directly from the underlying objects. Anyway, [the wrapper functions are off at the Technet Script Gallery as usual][2]. There is plenty of room for improvement but maybe you will get some use from it in your projects in its current form.

 [1]: /2014/03/07/posh-tip-convert-html-to-pdf/
 [2]: http://gallery.technet.microsoft.com/Powershell-WordExcel-d0791ece