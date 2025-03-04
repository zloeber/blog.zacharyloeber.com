---
title: Visualize Active Directory Site Connections
author: Zachary Loeber
type: post
date: 2013-10-06T22:50:35+00:00
excerpt: Use powershell with graphviz to create an Active Directory diagram of all site connections between servers
url: /blog/2013/10/06/visualize-active-directory-site-connections/
categories:
  - Active Directory
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration
  - Windows

---
#### <span style="color: #bbbbbb; font-size: 12px; font-weight: normal; line-height: 1.6;">In this post I use powershell with graphviz to create an Active Directory diagram of all site connections between servers. Additionally, I’ve included some code which displays site connection options. You may be able to use this to find isolated DCs or just to see a pretty diagram.</span>

<!--more-->

### Description

To actually generate the diagrams you will need graphviz’s dot.exe executable which can be downloaded and installed [here][1]. Or [here is a portable version][2] of the application you can try utilizing. All you need is for the dot.exe file to work correctly to generate your diagram. You may have to modify this script to use the appropriate path to the executable if you use the portable version of graphviz.

### Version

Version         :   1.0.0 Oct 6th 2013
  
&#8211; First release

### Screenshot

[<img style="margin: 5px; display: inline; background-image: none;" title="image" alt="image" src="/wp-content/uploads/2013/10/image_thumb.png?resize=244%2C132" width="244" height="132" border="0" data-recalc-dims="1" />][3]

### Notes

None. This was just a side thought I had while working on something else. The additional code for returning site connection options from AD is pretty cool as well.

### Downloads

[Download the script here][4]

 [1]: http://graphviz.org/
 [2]: https://code.google.com/p/graph-viz-portable/downloads/list
 [3]: /wp-content/uploads/2013/10/image.png
 [4]: http://gallery.technet.microsoft.com/Visualize-Active-Directory-0355005b