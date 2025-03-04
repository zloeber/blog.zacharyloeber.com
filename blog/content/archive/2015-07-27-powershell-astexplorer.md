---
title: 'PowerShell: ASTExplorer'
author: Zachary Loeber
type: post
date: 2015-07-27T16:27:55+00:00
url: /blog/2015/07/27/powershell-astexplorer/
categories:
  - Microsoft
  - Powershell
tags:
  - AST
  - Powershell
  - Powershell Script
  - PSC

---
So I&#8217;ve been working with PowerShell and abstract syntax trees as of late. Here is a tool I wish I had at my disposal when i started with all this. It takes your script, loads all the AST elements into a treeview, lists properties as each AST element is selected in the treeview, and highlights the portion of the script the element represents.

<!--more-->

Firstly, I cannot take credit for all of the code. I just revamped another project that used winforms in a single function. The link for the project is at the top line of the script for reference (equally worth checking out, especially if you are not running a more recent version of .NET). I converted the project to be a single xaml form, revamped the textbox a little, added a load button with dialog box, and did some other minor tweaks. There are some minor problems with highlighting text in the unfocused textbox control at times. If the selected text looks &#8216;off&#8217; then simply tab and shift-tab back to the treeview to correct the view. I lost patience with the xaml underpinnings of this issue. I&#8217;m welcome to suggestions on a fix to both that issue and a workable method for scrolling the textbox to the beginning of the selection automatically.

<div id="attachment_1466" style="width: 310px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2015/07/ASTExplorer-InAction.jpg"><img class="size-medium wp-image-1466" src="/wp-content/uploads/2015/07/ASTExplorer-InAction.jpg?resize=300%2C202" alt="Exploring AST with one of my scripts." width="300" height="202" srcset="/wp-content/uploads/2015/07/ASTExplorer-InAction.jpg?resize=300%2C202 300w, wp-content/uploads/2015/07/ASTExplorer-InAction.jpg?w=916 916w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Exploring AST with one of my scripts.
  </p>
</div>

Anyway, hope the community gets some use from this little tool. I&#8217;ve uploaded it to both the [Microsoft Technet Gallery][1] and [my Github repository][2] for your convenience.

 [1]: https://gallery.technet.microsoft.com/PowerShell-AST-Explorer-GUI-ce4839e2
 [2]: https://github.com/zloeber/ASTExplorer