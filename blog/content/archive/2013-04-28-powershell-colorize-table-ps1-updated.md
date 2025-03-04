---
title: 'Powershell: Colorize-Table.ps1 Updated'
author: Zachary Loeber
type: post
date: 2013-04-28T18:00:43+00:00
excerpt: 'Create an html table and colorize individual cells or rows of an array of objects based on row header and value. Optionally, you can also modify an existing html document or change only the styles of even or odd rows. '
url: /blog/2013/04/28/powershell-colorize-table-ps1-updated/
categories:
  - Powershell
  - System Administration
tags:
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration

---
A little while ago I released a script which uses custom linq assemblies to quickly modify an html table based on column header and an arbitrary scriptblock to test the values within that entire column (by default it is a simple -eq comparison). If the scriptblock evaluates to be true then you can either change just the cell style or the entire row style.

<!--more-->

This allows for extremely fast table rendering on existing html code. If you are clever you can do all kinds of other manipulations with this code but I&#8217;ve chosen not to abstract the function any further than basic html table manipulations. I&#8217;ve since rounded back on the script after getting some more linq and C# knowledge to make it far more readable and robust. Aside from the base features mentioned I&#8217;ve also added the ability to modify even and odd rows. Also, more comments have been added around the &#8220;add-type&#8221; command and the linq code has been refactored to be somewhat more legible.

You can dot source it into your script then run get-help colorize-table to get more information and examples.

[Downloaded the upgraded function at the Microsoft Technet Gallery][1]

 [1]: http://gallery.technet.microsoft.com/Colorize-HTML-Table-Cells-2ea63acd "Coloriz-Table Powershell Function"