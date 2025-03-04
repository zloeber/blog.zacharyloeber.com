---
title: Gather (and Diagram) Installed Roles and Features With Powershell
author: Zachary Loeber
type: post
date: 2013-12-18T18:53:18+00:00
excerpt: Use this powershell script to gather installed features and roles from remote systems.
url: /blog/2013/12/18/gather-and-diagram-installed-roles-and-features-with-powershell/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Microsoft
  - network administration
  - Powershell
  - PSC
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
Use this powershell script to gather installed features and roles from remote systems. This uses two wmi classes in an attempt to gather as much information as possible. Win32_ServerFeature will contain roles and their dependencies on systems running Windows 2008 and above. For these systems we can use this hierarchy to also produce pretty diagrams using graphviz and techniques I&#8217;ve exhibited in some of my other scripts (I added this last part in cause it is easy to do, not really certain how useful it is other than maybe exploring the dependencies between windows roles/features).

<!--more-->

To actually generate the diagrams you will need graphviz’s dot.exe executable which can be downloaded and installed [here][1]. Or [here is a portable version][2] of the application you can try utilizing. All you need is for the dot.exe file to work correctly to generate your diagram. You may have to modify this script to use the appropriate path to the executable if you use the portable version of graphviz.

### Version

1.0.1: 12/17/2013        &#8211; Initial release
  
1.0.0: 10/12/2013        &#8211; Initial creation

### Screenshot

[<img style="margin: 5px; display: inline; background-image: none;" title="2013-12-18 12_41_14-GVEdit For Graphviz ver_1.02" alt="2013-12-18 12_41_14-GVEdit For Graphviz ver_1.02" src="/wp-content/uploads/2013/12/2013-12-18-12_41_14-GVEdit-For-Graphviz-ver_1.02_thumb.png?resize=326%2C145" width="326" height="145" border="0" data-recalc-dims="1" />][3]

### Downloads

Download the most recent version of this script from [the Microsoft Technet Gallery][4]

 [1]: http://graphviz.org/
 [2]: https://code.google.com/p/graph-viz-portable/downloads/list
 [3]: wp-content/uploads/2013/12/2013-12-18-12_41_14-GVEdit-For-Graphviz-ver_1.02.png
 [4]: http://gallery.technet.microsoft.com/Gather-and-Graph-Remote-e2f022ec