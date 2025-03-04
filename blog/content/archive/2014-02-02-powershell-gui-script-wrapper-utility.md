---
title: Powershell GUI Script Wrapper Utility
author: Zachary Loeber
type: post
date: 2014-02-03T03:32:39+00:00
excerpt: This tool will parse a function or file with parameter elements and automatically generate a basic form with all the controls needed to generate the input for the function.
url: /blog/2014/02/02/powershell-gui-script-wrapper-utility/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Powershell
  - PSC
  - Scripting
  - Sysadmin
  - System Administration

---
Creating GUIs for your scripts can be a tedious process. That is why I don’t do so for each powershell project I release. Instead of wasting my precious little free time putting together yet another GUI for a one off script I decided to create a tool which will create the GUI scripts for me automatically!

<!--more-->

### About

This tool will parse a function or file with parameter elements and automatically generate a basic form with all the controls needed to generate the input for the function. This first release supports string (textbox), switch/bool (checkbox), and string with validateset defined (combobox). For many of my own functions and projects this is more than adequate.

I’ve also included a little mini project which resembles the output form from out-gridview (which I’m certain many are familiar with). Unfortunately Out-GridView requires the ISE be installed on whichever host you are running scripts on. The additional function I’ve included is called Out-GridViewForm and it gets around that requirement while still offering an easy way to view the array of psobjects which many scripts will spit out as their results. (I added an export to CSV button to this for kicks).

### Notes

As I put this together on a marathon hacking session with bleary eyes deep in to the darkness of the midnight hours there are bound to be issues with this first release. If you review the code please be kind to me. There are areas where I’m not using the most elegant techniques but it seems to get the goal accomplished so I’m not entirely unhappy with the results. Here are some general usage notes:

  * To get the best results from this script you will want to use a fully configured parameter block for your script with defined help messages and default values. A sample function which gathers the top 10 processes running by CPU utilization has been included for your convenience.
  * The code does its best to differentiate between a fully formed function block and a script file with parameters. In the cases where you use a file that is not a self contained function it will automatically create a GUI wrapper which tries to call the script file directly so file paths are important if you are looking for portability.
  * As always, I wrote this mainly to scratch an itch of my own (I use almost every script I write) and have released it to the community to give a little bit back. I welcome feedback of any kind as it motivates me to keep releasing more.

### Screenshots

[<img style="margin: 5px; display: inline; background-image: none;" title="screenshot1" alt="screenshot1" src="/wp-content/uploads/2014/02/screenshot1_thumb.jpg?resize=524%2C379" width="524" height="379" border="0" data-recalc-dims="1" />][1]

[<img style="margin: 5px; display: inline; background-image: none;" title="screenshot2" alt="screenshot2" src="/wp-content/uploads/2014/02/screenshot2_thumb.jpg?resize=518%2C229" width="518" height="229" border="0" data-recalc-dims="1" />][2]

[<img style="margin: 5px; display: inline; background-image: none;" title="screenshot3" alt="screenshot3" src="/wp-content/uploads/2014/02/screenshot3_thumb.jpg?resize=457%2C316" width="457" height="316" border="0" data-recalc-dims="1" />][3]

### Downloads

You can [get a zip of the PowerShell Studio 2012 project, a build of the executable, an export of the project as a single powershell script, and a few example input functions][4] from the Microsoft Technet Gallery.

 [1]: wp-content/uploads/2014/02/screenshot1.jpg
 [2]: wp-content/uploads/2014/02/screenshot2.jpg
 [3]: wp-content/uploads/2014/02/screenshot3.jpg
 [4]: http://gallery.technet.microsoft.com/Powershell-GUI-Script-97d98d9e