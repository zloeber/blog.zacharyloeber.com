---
title: 'PowerShell: Easy Module Authoring with ModuleBuild'
author: Zachary Loeber
type: post
date: 2017-07-05T01:29:53+00:00
url: /blog/2017/07/04/powershell-easy-module-authoring-with-modulebuild/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Microsoft
  - Powershell
  - Powershell Script

---
I’ve previously discussed using the excellent plaster module for creating new modules among other things. Now I’ve integrated plaster into my PSModuleBuild project, turned the whole thing into a module, and changed the name to just ‘ModuleBuild’

<!--more-->

PSModuleBuild was one of my lofty attempts to simplify my PowerShell module build process and it adequately met most of my personal needs. But it had some major drawbacks including;

  * Over-complicated task processing
  * New project initialization was a pain
  * Migrating existing projects to my new build system was entirely manual.
  * Configuration was entirely based on manual file editing

As I looked into plaster and became entirely too enamored with the project I slowly came to realize that PSModuleBuild should probably just be a module itself and started making that thought a reality. But when I got to the point of publishing to the psgallery I found to my dismay that another module with that name already existed. You snooze you lose right?

No worries, I used my new module to initialize a project called ‘ModuleBuild’ and copied everything from PSModuleBuild and did a little recursive find and replace magic. Now, the project is called ModuleBuild! And honestly, the number of additions and changes to the project almost warrants a new name anyway so I’m not lamenting the change. Let’s talk about some of these feature updates shall we?

# ModuleBuild Features

ModuleBuild retains many of the features of PSModuleBuild but is now much cleaner and runs as a module. The module itself is used to initialize new projects or ease getting/setting changes for existing ModuleBuild projects. The module also includes helpers for migrating existing projects to a ModuleBuild project. Loading the ModuleBuild module is not a requirement to run a build for your project though, that is still entirely portable as it has always been.

Some of the features I’ve included in this project include:

  * Fully portable project directory structure and build process. So portable that you can copy it to another PowerShell 5.0 capable system and it should run the same.
  * Automatically combine your public and private functions into one clean psm1 file at build time.
  * Automatically update your psd1 file with public functions at build time.
  * Automatically scan your module release with PSScriptAnalyzer
  * Automatically upload your script to the PowerShell Gallery (with appropriate API key)
  * Automatically create project documentation folder structure and yml definition file for ReadTheDocs.org integration
  * Visual Studio Code integration (tasks)
  * Easy to manage build configuration with forward compatible design and easy to use commands
  * Includes ability to scan for sensitive terms (like your company domain name or other items that you may not want published)
  * Helper functions to import existing project private and public functions into your ModuleBuild based project

# Getting Started

I&#8217;m going to run through an example based on a real migration of project code into a ModuleBuild based project. This project is an advanced ADSI project that I&#8217;ve been meaning to release for a long time but never quite got to completing. The module currently works which is all we really need in order to migrate things over to a ModuleBuild backed project. My module name is tentatively going to be called &#8216;PSAD&#8217; (PowerShell AD).

Firstly, the PowerShell 5.0 requirement for this project has not changed. You can install the project from the PowerShell Gallery to start:

<pre class="lang:powershell decode:true" title="Installing ModuleBuild">install-module ModuleBuild -Scope:CurrentUser</pre>

Once you have the module we will go ahead and initialize a new modulebuild based project. For now I just create the project in a temporary directory as the whole thing is portable and can be moved anywhere when I&#8217;m happy with things.

<pre class="lang:powershell decode:true">Import-Module ModuleBuild
Initialize-ModuleBuild -Path 'C:\Temp\PSAD'</pre>

When prompted, select most default options including using the creative commons license, ReadTheDocs integration, module auto-combine, and sensitive term scanning. Note that the project website I enter doesn&#8217;t exist yet **but it isn&#8217;t just a filler either**, I can plausibly create the site in my github account (and will when I&#8217;m happy with the project and am ready to upload).

<div id="attachment_1724" style="width: 310px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2017/06/2017-06-18_20-03-51.gif"><img class="size-medium wp-image-1724" src="/wp-content/uploads/2017/06/2017-06-18_20-03-51.gif?resize=300%2C135" alt="" width="300" height="135" srcset="/wp-content/uploads/2017/06/2017-06-18_20-03-51.gif?resize=300%2C135 300w, wp-content/uploads/2017/06/2017-06-18_20-03-51.gif?resize=768%2C346 768w, wp-content/uploads/2017/06/2017-06-18_20-03-51.gif?resize=1024%2C461 1024w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    ModuleBuild Initialization
  </p>
</div>

That will create pretty much everything we need for the module but we will still need to get all the public and private functions in place. But before then I need to modify the sensitive scan search settings and remove my user ID as I already know that is the same user ID used in my github account so the build will certainly fail (due to my project website having that string within it). I&#8217;m also going to add my own Nuget API key so I can publish to the psgallary. I leave in my short and long domain names though. You will need to modify this sensitive terms list to suit your needs.

<pre class="lang:powershell decode:true">Set-Location C:\Temp\PSAD
Set-BuildEnvironment -OptionSensitiveTerms 'CONTOSO', 'CONTOSO.COM'
Set-BuildEnvironment -NugetAPIKey '00000000-0000-0000-0000-00000000000'</pre>

> **NOTE:** The <modulename>.buildenvironment.json configuration file is automatically ignored in an included git configuration file so your api keys and any other sensitive information will always remain local to your workstation.

## Importing Public Functions

If this were a new module then all I&#8217;d need to do is start creating public functions (ideally one per file but that is not an absolute requirement) in src\public. But since I&#8217;ve got an existing module project I&#8217;m importing there are a few things I can do to kickstart things. Firstly, lets import the public functions from the module (located in c:\c-temp\PSAD)

<pre class="lang:powershell decode:true ">Import-ModulePublicFunction -ModulePath 'C:\c-temp\PSAD\PSAD.psm1'</pre>

This assumes we are in the project folder and will automatically find the buildenvironment.json file to use. Be cognizant that the direct psm1 file is specified and not the psd1. If you have a psd1 file that is setup with properly defined public functions you can use it as well. In either case the module will need to be loaded so we can ascertain what the public functions actually are.

Each found public function will be found and will be prompted for import if the file doesn&#8217;t already exist. If no comment based help is found within the function block, then a default one will be created so we can have a higher likelyhood of a successful build later on.

## Importing Private Functions

Private functions are far more nebulous and finding/importing the right ones is a bit of an art. We still load the source module to determine the proper public functions (so they are able to be properly negated as import candidates). But beyond that it is really just guesswork. This part of the import process scans most of the files in the module based directory recursively and looks for top level function definitions that are not public functions and then prompts before importing to your project src\private folder. I&#8217;d closely look over each prompt before importing the function.

<pre class="lang:powershell decode:true ">Import-ModulePrivateFunction -ModulePath 'C:\c-temp\PSAD\PSAD.psm1'</pre>

## Other Items

If you have any pre or post loading code that your existing module requires then place it in either the src\other\preload.ps1 or src\other\postload.ps1 files.

You should also setup some basic documentation. Keep in mind that your function documentation will automatically be built at build time. Most of the other documentation gets automatically built at build time as well and should be modified in your build\docs folder directly. One bit of documentation that doesn&#8217;t automatically update from the build\docs directory is the base folder readme.md file. You should fill this out more as it will be the first thing people see on github when they stop by for a visit.

## Kick Off A Build

At this point if you think you are ready to go then kick off a build with the included Build.ps1 file. When I do this for the project I run into a few game stoppers. Apparently I didn&#8217;t name some parameters correctly in my comment based help (and in some cases had them entirely wrong or missing!).

<div id="attachment_1728" style="width: 310px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2017/07/ConEmu_2017-07-04_13-32-12.jpg"><img class="size-medium wp-image-1728" src="/wp-content/uploads/2017/07/ConEmu_2017-07-04_13-32-12.jpg?resize=300%2C135" alt="" width="300" height="135" srcset="/wp-content/uploads/2017/07/ConEmu_2017-07-04_13-32-12.jpg?resize=300%2C135 300w, /wp-content/uploads/2017/07/ConEmu_2017-07-04_13-32-12.jpg?resize=768%2C346 768w, /wp-content/uploads/2017/07/ConEmu_2017-07-04_13-32-12.jpg?w=954 954w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Missing comment based help will stop a build from succeeding.
  </p>
</div>

So I cancel the build (ctrl+c) and go back to each of the referenced files to fix the CBH. After that has been done I build again:

<div id="attachment_1729" style="width: 301px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2017/07/2017-07-04_14-34-17.gif"><img class="size-medium wp-image-1729" src="/wp-content/uploads/2017/07/2017-07-04_14-34-17.gif?resize=291%2C300" alt="" width="291" height="300" srcset="/wp-content/uploads/2017/07/2017-07-04_14-34-17.gif?resize=291%2C300 291w, /wp-content/uploads/2017/07/2017-07-04_14-34-17.gif?resize=768%2C791 768w" sizes="(max-width: 291px) 100vw, 291px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    A successful build!
  </p>
</div>

Once this has completed you will have a release worthy module in your release\<modulename> directory. But wait, there&#8217;s more!

You can automatically install and load the module (to test loading it) and upload to the powershell gallery. Oh, you can do all of this within [Visual Studio Code][1] by pressing ctrl+shift+B and selecting a task as well.

&nbsp;

## Some Notes

Due to the complexity of a pipeline like this there are several nuances to be aware of. I document many of these in the documentation. Regardless, here are a few answers to questions you may already be asking:

**Question:** Why is there no git integration?

git workflows can vary greatly between different people and development teams so I&#8217;ll just leave that part of a build to your capable hands. It is exceedingly easy to add additional tasks to modulebuild too (as it is really just a set of invoke-build tasks).

**Question:** Why does ModuleBuild not include <whatever spins your top>?

I&#8217;ve not gotten to it yet or I don&#8217;t use <whatever spins your top>. If you think it should be added and you want me to do the work then make a case for the feature [at the github site][2].

## Final Words

ModuleBuild is built with its own scaffolding which has ReadTheDocs integration. As such, you can read over more options, guidelines, and other things you may want to do with ModuleBuild at [its ReadTheDocs site][3]. Otherwise you can install the current version of ModuleBuild and get to authoring your own PowerShell modules right away:

<pre class="lang:powershell decode:true">Install-Module modulebuild -scope CurrentUser</pre>

Github Site: [ModuleBuild][2]

ReadTheDocs Site: [Documentation][3]

I hope to get some feedback from others out there using this project. I look forward to suggestions for features and improvements. Happy PowerShell module authoring!

 [1]: https://code.visualstudio.com/
 [2]: https://github.com/zloeber/ModuleBuild
 [3]: http://modulebuild.readthedocs.io/en/latest/