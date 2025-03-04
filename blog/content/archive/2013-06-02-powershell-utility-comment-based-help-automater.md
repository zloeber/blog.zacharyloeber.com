---
title: 'Powershell Utility: Comment Based Help Automater'
author: Zachary Loeber
type: post
date: 2013-06-02T20:05:05+00:00
excerpt: This little powershell based GUI helps fellow coders automatically construct comment based help blocks for their functions.
url: /blog/2013/06/02/powershell-utility-comment-based-help-automater/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Powershell
  - Scripting
  - Sysadmin

---
Comment based help is used in powershell-land to provide fast and easy help for cmdlets at the console. This little powershell based GUI helps fellow coders automatically construct comment based help blocks for their functions.

<!--more-->

# **About**

Comment based help allows you to run ‘get-help <command />’ at a powershell console to get more information about a cmdlet or function. And it is extremely easy to add comment based help to your own custom powershell functions with a specially formatted comment block just before, or immediately inside of a function.

Unfortunately only a third of powershell functions I’ve come across on the internet have the appropriate comment blocks included with them. This utility aims to make it easier for script writers to add comment based help to their scripts with an easy to use GUI which can automatically capture all the parameters of their function (as well as any specified HelpMessage if it exists).

# **Version**

Version         :   1.0.0 May 31th 2013
  
&#8211; First release

# **Notes**

The zip includes a stand-alone ps1 script, a compiled executable of the script, and a folder with all the project files I put together with Sapien Powershell Studio 2012.

The hardest part of this script was converting the text to a script block and trying to figure out all the ways to yank out parameters with [Management.Automation.PSParser]::Tokenize. If you are purely interested in that aspect of the tool you can find the function “Get-FunctionParameters” in the globals.ps1 script with the project files. The one item I’ve not resolved is parsing out a parameter which is of type [ScriptBlock] with a default value set (something with the curly braces but I’ve not put too much effort into this due to its infrequent occurrence).

This utility will only parse a single function at a time. In fact, you only need to supply the param block to get the full results.

# **Screenshots**

<div id="attachment_787" style="width: 310px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2013/06/CBH-Example.jpg"><img class="size-medium wp-image-787" alt="Comment Based Help Main Screen" src="/wp-content/uploads/2013/06/CBH-Example-300x188.jpg?resize=300%2C188" width="300" height="188" srcset="/wp-content/uploads/2013/06/CBH-Example.jpg?resize=300%2C188 300w, /wp-content/uploads/2013/06/CBH-Example.jpg?w=925 925w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Comment Based Help Main Screen
  </p>
</div>

<div id="attachment_788" style="width: 277px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2013/06/Options.jpg"><img class="size-medium wp-image-788" alt="Options to select for comment based help construction" src="/wp-content/uploads/2013/06/Options.jpg?resize=267%2C300" width="267" height="300" srcset="/wp-content/uploads/2013/06/Options.jpg?resize=267%2C300 267w, wp-content/uploads/2013/06/Options.jpg?w=560 560w" sizes="(max-width: 267px) 100vw, 267px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Comment based help options
  </p>
</div>

# **Conclusion**

I hope that this little tool finds its way into fellow scripter’s utility collections. Give me a holler if you have any ideas for improvement (or improve it yourself!).

# Download

[Microsoft Technet Gallery][1]

[Right Here][2]

 [1]: http://gallery.technet.microsoft.com/Powershell-Utility-Comment-da6baaf3
 [2]: /wp-content/uploads/2013/06/New-CommentBasedHelp.zip "Right Here"