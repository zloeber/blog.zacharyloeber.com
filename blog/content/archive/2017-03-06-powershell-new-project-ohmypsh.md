---
title: 'PowerShell: New Project – OhMyPsh'
author: Zachary Loeber
type: post
date: 2017-03-07T03:05:19+00:00
url: /blog/2017/03/06/powershell-new-project-ohmypsh/
categories:
  - Microsoft
  - Powershell
tags:
  - Powershell
  - Scripting
  - Windows

---
A PowerShell 5.0 terminal experience with lots of smart features that make you look cool at the command line.

<!--more-->

Ok, so the ‘zinger’ line at the beginning of this post sounds like a sales pitch for a motorcycle or something but it is an apt description given the amount of features I’ve baked into this module. Here is probably a more accurate description:

> OhMyPsh is a personal profile management and profile loading wizard for PowerShell 5.0 (and greater) users that uses a simple json configuration file to manage plugins, themes, module auto-loading, module upgrading, module cleanup, and other chores so that you can be more productive in the shell.

Before I go over what this module does, lets get a short background of why I went off the deep end and coded this project shall we?

## Background

This project started with a simple need to be able to quickly use one off scripts without the need to put them in my profile or dot source them. I also wanted to be able to distribute scripts to my team without having to give instructions for how to get them to work or worry too much about prerequisite modules and other nonsense. Finally, I wanted to be able to quickly replicate my console experience between systems, automate module upgrades, and just make my PowerShell experience smarter in general.

In looking for already created solutions for this kind of thing I first looked at [a highly customized powershell profile][1]. But this setup suffers from several drawbacks, most notably that you have to maintain the profile itself. It is also not easy to add/remove features without a bunch of manual effort and it is certainly not portable.

I found a few other projects that have the same name but are totally different incarnations of the same concept. These are as follows:

[Oh-My-Posh (pecigonzalo)][2] &#8211; Powershell amazingness inspired on Oh-My-Zsh, pshazz, fish. This provides a repository for PowerShell Customizations.
  
[Oh-My-Posh (JanJoris)][3] &#8211; A prompt theming engine for Powershell running in ConEmu

The first oh-my-posh listed above was more heavily structured around the original oh-my-zsh. It includes plugins and other such fun but I found that the code structure didn’t quite suit my needs. Besides, a zsh structured shell doesn’t necessarily carry over well to a Windows or Powershell based system. Regardless, I can honestly say that this was the module that inspired this project.

The second listed oh-my-posh above had some great ideas around theming and I really like it as well. It didn’t have any other real features though. It is also Conemu based with many of the theme prompts reliant upon the author’s favorite fonts.

Another module worth mentioning is [PSColor][4]. If you want to ‘theme’ your console it involves intercepting the ‘out-default’ function which is generally called at the end of every baked in cmdlet in PowerShell. I initially was going to make PSColor a required module but there was a fatal flaw in its implementation that broke the out-default function upon unloading the module. I fixed this issue and submitted a pull request for the project but it hasn’t been merged as of yet. I decided simply to simply absorb the functionality of this module into oh-my-psh as that solves several issues for me and ensures that theming always works with my module the way it is intended to.

That all being said, I started building my own version of oh-my-psh and went totally off the deep end. Lets talk features shall we?

## Features

OhMyPsh includes several appealing features for the PowerShell user. This included (but is not limited to):

  * Automatic module updating (Via psget)
  * Automatic old module cleaning (Via psget)
  * Easy to add, load, and unload plugins
  * Theming (psreadline)
  * Persistent custom profile settings.
  * Integrated PSColor output (that can safely be unloaded)

## Installation

Simple, this a PowerShell 5.0 based module that can be installed with a single command:

<pre class="lang:powershell decode:true">install-module ohmypsh -scope:currentuser</pre>

## Use

Again, simple stuff:

<pre class="lang:powershell decode:true">import-module ohmypsh</pre>

But when you import the module nothing will change. That&#8217;s cool, lets spruce things up a little.

<pre class="lang:powershell decode:true">Add-OMPPlugin psreadline
Add-OMPPlugin pscolor
Add-OMPPlugin banner
Add-OMPPlugin psdefaultparams
Add-OMPPlugin qod
Add-OMPPlugin fzf
Add-OMPPlugin powerline
Add-OMPPlugin psgit
Add-OMPPlugin moduleupgrade
Add-OMPPlugin moduleclean
Set-OMPTheme powerline</pre>

This particular setup includes a theme that works very well with Conemu (which my favorite console app, cmder, wraps nicely around). If you are just using a plain powershell prompt then you may want to give either the jaykul or golagola themes a whirl instead.

## Related Projects/Credits

This project is [hosted on github][5] and I welcome pull requests.

Here are some of the other references project sites, you should check &#8217;em out too.

\[PSColor\]([https://github.com/Davlind/PSColor)][4]
  
\[PSReadline\]([https://msdn.microsoft.com/en-us/powershell/reference/5.1/psreadline/psreadline)][6]
  
\[Oh-My-Posh (pecigonzalo)\](<https://github.com/pecigonzalo/Oh-My-Posh)>
  
\[Oh-My-Posh (JanJoris)\](https://github.com/JanJoris/oh-my-posh)

 [1]: https://github.com/zloeber/PowerShellProfile
 [2]: https://github.com/pecigonzalo/Oh-My-Posh
 [3]: https://github.com/JanJoris/oh-my-posh
 [4]: https://github.com/Davlind/PSColor
 [5]: https://github.com/zloeber/OhMyPsh
 [6]: https://msdn.microsoft.com/en-us/powershell/reference/5.1/psreadline/psreadline