---
title: 'PowerShell: New Project – PSModuleBuild'
author: Zachary Loeber
type: post
date: 2016-08-01T02:34:55+00:00
url: /blog/2016/07/31/powershell-new-project-psmodulebuild/
categories:
  - Microsoft
  - Powershell
tags:
  - Microsoft
  - Powershell
  - Powershell Script
  - Scripting

---
I’ve spent a little bit of time thinking about and putting together a proper build script for one of my projects. This post covers the decisions I made and technologies I used to get this set this up.

<!--more-->

## Long-Winded Introduction

I’ll let you in on a dirty secret of mine (which I’m starting to realize is a recurring theme in my posts). I’ve probably just as much unpublished code in my personal library as I do published code. To understand why this is the case it is beneficial to quickly go over the categories of scripts I generally think we all tend to write.

**One-Shot** – This is on-the-fly or single purpose code that you whip together to accomplish one specific or on-demand task. These may be one-liners but don’t have to be. I tend to write these to save me tons of manual efforts in my day to day job. I probably have hundreds of these spread out between dozens of folders. These scripts tend to use hard coded file, domain, and server names which make them completely unsuitable for sharing.

**Generic** –These scripts may be one-shot scripts that have evolved because it was discovered that they needed to be reused repeatedly. These are usually still pretty specific but only need a few minor modifications to be something that the wider public may get value from. A larger portion of my released scripts over the years have been generic scripts. One big decision you usually have to make when making these kinds of scripts are if you want to make them dot-sourced functions or stand-alone scripts.

**Project** – This is almost always a collection of scripts and may even be a formal module. Although a project may have been built to meet a specific need of your own they are also written to appeal to a wider audience. If you find yourself looking into the nuances of script scope, considering pester testing, and pushing things up to psgallery then you are likely working on a project.

Most of my scripts are simply ‘one-shot’. That’s not bad, it’s simply a result of being very busy earning my livelihood. Much of my generic scripts are also not fully ready to be published due to time constraints and not having been cleaned up enough to be deemed worthy.

My ‘Project’ scripts/modules are what I feel rather guilty about. These were specifically created for the community (and my own needs obviously) but I often don’t update them as frequently as my local copies of the code. This is largely due to the stupid number of manual steps required to get the project published. I simply don’t like doing that kind of menial work. This is where the ‘build’ script comes into play!

## What Is A Build Script?

Those with any Linux background may have experience with build scripts if they ever had to manually compile a packages. In a basic install without customization you would download a .tar.gz archive, extract it locally and then run the following from within the directory:

<pre class="lang:zsh decode:true ">sudo su -
configure && make && make install</pre>

This may also look like this..

<pre class="lang:zsh decode:true ">configure
make
sudo make install</pre>

or this…

<pre class="lang:zsh decode:true ">configure && make && sudo make install</pre>

<span style="line-height: 1.6;">or this (if it is a simple package without any pre-configuration actions or prerequisite checks)….</span>

<pre class="lang:zsh decode:true ">make && sudo make install</pre>

<span style="line-height: 1.6;">It doesn’t matter a whole lot how the build process looks the general idea is that you downloaded the source for some project and need to get it up and running on your system. Using a build process, you can apply system specific flags and optimizations. Heck, whole distributions of Linux have been created around the build process (can anyone </span><a style="line-height: 1.6;" href="https://wiki.gentoo.org/wiki/FAQ#What_makes_Gentoo_different.3F">say Gentoo</a><span style="line-height: 1.6;">?).</span>

Anyway, back to Windows and PowerShell! A build process is one way to automate the process of getting your source from one state to another (compiled or otherwise). You can use a custom PowerShell script as a build script in its own right. In fact, that’s what many people do. I started doing this myself one of my modules but came across a pretty cool project called ‘Invoke-Build’ and decided to learn and use it instead.

# Why Invoke-Build?

Firstly, why use Invoke-Build? There is [an extensive wiki][1] for the project that really gets to the heart of what a build script should be. You can tell the author really put thought and effort into the project and I cannot commend his efforts enough. My number one reason for using invoke-build is that it is 100% PowerShell and 100% portable.

This means I can package up a project with the invoke-build script and a batch or other PowerShell file and be able to get my entire build environment running on another computer with just a few lines. This is more important than you might realize. Sure I’m likely the only person who will be releasing builds of my project but if I have to get a whole environment in place every time I move to another computer then it kind of defeats the purpose of automating the build process. Additionally, I believe that if I’m releasing code it will also be beneficial to anyone else who ever may want to pick up the project to do so.

Regardless, invoke-build also helps me deploy my release in a logical task oriented manner. Others have taken invoke-build and [expanded upon it for boilerplate build scripts for .Net projects][2] and other complex developer related build tasks. So I figured my meager PowerShell module build requirements would be easy to accomplish with Invoke-Build. I found that I wasn&#8217;t mistaken but there were a few nuances.

## Invoke-Build Nuances

I’m not a developer by trade I found that I had some mental hurdles to overcome to use this excellent build engine. I’d like to cover some of these hurdles for those who are interested in using the project for their own needs.

### The Code is Complex, Really Complex

The first nuance with invoke-build is that the code itself makes me feel like a cretin with PowerShell. It is not the kind of code I’ve ever worked with or seen before and I’m not certain I could unwind its logic without a whole lot more time than I currently have (though I would, and could if I had to do so!).

### A Build is Just a Bunch of Tasks

Invoke-build is, at its core, a task engine. You define a handful of independent, single instance, tasks and link them together to build a project. If any task in that chain fails, then the whole build fails. There are some exceptions to this (such as running a task with the -safe flag) which will show the task failure but still move on to the next task in the list. You link a bunch of tasks together with commas. Here is a task that is simply a list of other tasks that get called in order:

<pre class="lang:powershell decode:true ">task TestCodeFormatting Configure, Clean, PrepareStage, FormatCode</pre>

<span style="line-height: 1.6;">This defines TestCodeFormatting which calls configure, clean, preparestage, and formatcode in that order. If the clean task fails (maybe you have a subdirectory open in windows explorer or something) then the whole TestCodeFormatting task fails.</span>

Each of the tasks in this list may consist of multiple linked tasks of their own. For instance, the &#8216;Configure&#8217; task referenced above is actually several tasks in its own right. Here is how that task is defined:

<pre class="lang:powershell decode:true">#Synopsis: Validate script requirements are met, load required modules, load project manifest and module, and load additional build tools.
task Configure ValidateRequirements, LoadRequiredModules, LoadModuleManifest, LoadModule, Version, LoadBuildTools, {
    # If we made it this far then we are configured!
    $Script:IsConfigured = $True
    Write-Host -NoNewline ' Configure build environment'
    Write-Host -ForegroundColor Green '...configured!'
}</pre>

You will immediately see that this is a list of tasks that finishes with a code block of its own. Each task is essentially a named code block. You can string multiple code blocks together if you like (though the usefulness of such an exercise is questionable). Here is an example of such a thing if it helps get the point across at all:

<pre class="lang:powershell decode:true">Function AreWeConfigured ($Configured) {
    if ($Configured) {
        Write-Host -ForegroundColor Green '...Yup!'
    }
    else {
        Write-Host -ForegroundColor Red '...Nope!'
    }
}
# Synopsis: Test configuration of a task.
task . {
    $Script:IsConfigured = $False
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}, {
    $Script:IsConfigured = $True
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}</pre>

If you save this code as ‘.build.ps1’ then you don’t have to specify a build file when you call invoke-build. Look at the task that I defined as well. It is simply a period. This denotes the default task. So you would run this build by simply calling ‘invoke-build’ in the directory of the .build.ps1 file!

The output is kind of how we would expect it to look:

[<img style="margin: 0px; display: inline; background-image: none;" title="clip_image001" src="/wp-content/uploads/2016/07/clip_image001_thumb.png?resize=244%2C52" alt="clip_image001" width="244" height="52" border="0" data-recalc-dims="1" />][3]

### Each Task Runs Only Once

This is a minor nuance but important one to remember once you start to get a fair number of tasks to chain together. The moment a task&#8217;s script block gets executed it will not ever execute again (successful or otherwise) within the current process. When a task is skipped because it already completed in another task sequence or gets skipped for other reasons (-if conditional operator defined in the task) it shows as gray output.

### Beware of Scoping

Each task maintains its own scope like any other code block in PowerShell. This is logical but in a larger set of tasks with multiple variables and dependent steps you should be careful not to forget this fact. Here is an example where I’ve not created a variable at the script scope level and so it fails to test as being true in a later task:

<pre class="lang:powershell decode:true">Function AreWeConfigured ($Configured) {
    if ($Configured) {
        Write-Host -ForegroundColor Green '...Yup!'
    }
    else {
        Write-Host -ForegroundColor Red '...Nope!'
    }
}
#Synopsis: Test configuration of a task.
task . {
    $IsConfigured = $True
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}, {
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}</pre>

The result of this build:

[<img style="margin: 0px; display: inline; background-image: none;" title="clip_image002" src="/wp-content/uploads/2016/07/clip_image002_thumb.png?resize=244%2C53" alt="clip_image002" width="244" height="53" border="0" data-recalc-dims="1" />][4]

Now if we create the variable at the script level and run this same code:

<pre class="lang:powershell decode:true">Function AreWeConfigured ($Configured) {
    if ($Configured) {
        Write-Host -ForegroundColor Green '...Yup!'
    }
    else {
        Write-Host -ForegroundColor Red '...Nope!'
    }
}

$IsConfigured = $False

#Synopsis: Test configuration of a task.
task . {
    $IsConfigured = $True
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}, {
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}</pre>

We get the same result!

**[<img style="margin: 0px; display: inline; background-image: none;" title="clip_image003" src="/wp-content/uploads/2016/07/clip_image003_thumb.png?resize=244%2C52" alt="clip_image003" width="244" height="52" border="0" data-recalc-dims="1" />][5]**

If you want to update the $IsConfigured variable within a task you need to reference it at the script scope level when updating it otherwise you will not get the results you were expecting.

<pre class="lang:powershell decode:true ">Function AreWeConfigured ($Configured) {
    if ($Configured) {
        Write-Host -ForegroundColor Green '...Yup!'
    }
    else {
        Write-Host -ForegroundColor Red '...Nope!'
    }
}

$IsConfigured = $False

#Synopsis: Test configuration of a task.
task . {
    $Script:IsConfigured = $True
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}, {
    Write-Host -NoNewline ' Are we configured here?'
    AreWeConfigured $IsConfigured
}</pre>

The results:

[<img style="margin: 5px; display: inline; background-image: none;" title="clip_image004" src="/wp-content/uploads/2016/07/clip_image004_thumb.png?resize=244%2C52" alt="clip_image004" width="244" height="52" border="0" data-recalc-dims="1" />][6]

> **Note:** If you are paying attention you will see that in one code block I update the $IsConfigured variable at the script scope level ($Script:IsConfigured) and then in the next code block I call the AreWeConfgured function with the $IsConfigured as the parameter and it still appears to reference the script scoped variable! I don’t know why this is, maybe it is a bug but to be 100% safe I recommend manually defining your variables that cross task boundaries at the top of your build script and then explicitly referencing them at the script scope level.

Oh, be nice to your PowerShell environment and don’t start using the global scope level. It leaves all kinds of crap and extra variables loaded after the script runs and just feels amateurish.

### There are a Few Paths of Logic

The idea of a task within invoke-build is quite simple but the actual processing within the engine isn’t all that straightforward. The first time a task is defined is one path of logic. Then when a task is called there is another path of logic. I contacted the author about this as [I was completely stumped on defining a task with an -if conditional statement][7]. The gist of the confusion is that I didn’t realize you can define the conditional in one of two ways, with curly braces or with parenthesis.

<pre class="lang:powershell decode:true ">task SomeTask -If {$SomeCondition} {...}
task SomeTask -If ($SomeCondition) {...}</pre>

The curly braces conditional statement gets evaluated whenever the task is called. The parenthesis conditional statement only gets evaluated when the task is loaded into the engine. If you use the ‘-WhatIf’ parameter on invoke-build the parenthesis conditional will still need to evaluate as true to run as well. There are use case scenarios for this all but for now, simply knowing the difference is important.

# My Module Build Script

I started this thought process with one thought that then spiraled out of control into several other tasks. The initial thought was to have a consistent location for my most recent build of a script project from a installer script location that I could keep on a rolling release cycle while allowing for the older versions to still be accessible for download. This is basic stuff that you see all over the place for many projects. One example off the top of my head is the great [Carbon powershell project][8]. The downloads directory has every released version available. I couldn&#8217;t imagine doing that kind of thing manually.

After [some discussion][9] about PowerShell module best practices and combining module code into one psm1 file I decided to finally tackle this build script thing and was able to do a whole lot more than automate my project downloads directory. The current version of my invoke-build script for modules does the following:

  * Configure the build environment 
      * dot sources additional functions used in the build process
      * Installs and loads any missing modules used in the build process
      * Loads the project module manifest information for later processing
      * Loads and validates that the current release version matches the module manifest version
  * Optionally can update the current module manifest version to the release version
  * Recreates the scratch/staging area for processing
  * Pulls all the public function names and creates a new module manifest with them
  * Runs all code through code formatting (if you like, I&#8217;m still tweaking the module behind this one so it is disabled by default)
  * Combines all public/private/other source for the module into a single psm1 file
  * Runs PSScriptAnalyzer against the module
  * Creates online markdown help files for the module with PlatyPS
  * Creates the module xml help files with PlatyPS
  * Creates the downloadable CAB file for the module with PlatyPS
  * Optionally, update a Powershell Gallery local profile file with release notes, and pushes an update to the module to the gallery (I wrote a few helper functions just for this).

I&#8217;ve basically reduced my manual steps for releasing a module down to a handful of commands. It looks a bit wonky but here is a dependency graph of the current build file as it pertains to one of my modules to help visualize some of these tasks.

<div id="attachment_1633" style="width: 160px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2016/07/buildgraph.gif"><img class="size-thumbnail wp-image-1633" src="/wp-content/uploads/2016/07/buildgraph.gif?resize=150%2C150" alt="Build task diagram" width="150" height="150" srcset="/wp-content/uploads/2016/07/buildgraph.gif?resize=150%2C150 150w, wp-content/uploads/2016/07/buildgraph.gif?zoom=2&resize=150%2C150 300w, wp-content/uploads/2016/07/buildgraph.gif?zoom=3&resize=150%2C150 450w" sizes="(max-width: 150px) 100vw, 150px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Build task diagram
  </p>
</div>

The entire Invoke-Build definition script is in .build.ps1 but I also include a build.ps1 which can be run to kick the build process off. Both files are in my [FormatPowerShellCode module project][10]. I&#8217;ve started the process of creating a starter scaffolding script in a project that includes this build engine and several tasks in a shell script. It is called PSModuleBuild and can be found [here][11]. If you want to give it a whirl I&#8217;ve put some general guidelines and notes in the readme.md file for this project. It is only a general build script so don&#8217;t expect it to handle anything really complex (or anything more than a pure script module for that matter). But the base build task file is very easy to modify to suit your own needs.

# Build Script Notes

  * I&#8217;m to keep any function documentation within the comment based help for the function. The build process uses PlatyPS to generate the relevant help files and will fail if &#8220;{{ blah blah blah }}&#8221; is found to have been created in the output files (as these are meant to be replaced manually for any information PlatyPS is unable to locate). The CBH gets replaced with the generated module documentation for each function based on the .SYNOPSIS comment based help existing. This is done in the following task:

<pre class="lang:powershell decode:true">task UpdateCBH -Before CreateModulePSM1 {
    $CBHPattern = "(?ms)(\&lt;#.*\.SYNOPSIS.*?#&gt;)"
    Get-ChildItem -Path "$($ScratchPath)\$($PublicFunctionSource)\*.ps1" -File | ForEach {
            $FormattedOutFile = $_.FullName
            Write-Output "      Replacing CBH in file: $($FormattedOutFile)"
            $UpdatedFile = (get-content  $FormattedOutFile -raw) -replace $CBHPattern, $ExternalHelp
            $UpdatedFile | Out-File -FilePath $FormattedOutFile -force -Encoding:utf8
    }
}</pre>

  * I recreate the documentation markdown files every time I run the build. This includes the module landing page. PlatyPS doesn&#8217;t seem to automatically pull in function description information (or I&#8217;m missing something in the usage of this module) so I do so within another task behind the scenes.
  * I keep a single line file at the root of my project called version.txt which I update to reflect the current build I&#8217;m working on. If this version and the version in the current manifest file do not match the build will fail. If I want to update the version to match I&#8217;ve created a task for doing so:

<pre class="lang:powershell decode:true ">Invoke-Build UpdateVersion</pre>

  * I do not push the current build automatically to the Powershell Gallery. When I&#8217;m ready to push to the gallery I have another task I can use which will update a pre-existing gallery configuration file and then publish the module. You will first need to create a local .psgallery profile. This can be done with the current module manifest information and the following command:

<pre class="lang:powershell decode:true ">Invoke-Build NewPSGalleryProfile</pre>

<p style="padding-left: 30px;">
  The helper scripts used to actually publish the module in the gallery require a Nuget API key (can be quickly attained with your account at <a href="https://www.powershellgallery.com/">the Powershell Gallery site</a>) which is pulled in a file in your powershell profile called psgalleryapi.txt. You can create this key file with the following command:
</p>

<pre class="lang:powershell decode:true">notepad (Join-Path (Split-Path $profile) 'psgalleryapi.txt')</pre>

<p style="padding-left: 30px;">
  Once everything is in place you can upload your project to the PowerShell Gallery with the following task at any time. Note that the current version and module name are inferred from the module manifest file.
</p>

<pre class="lang:powershell decode:true">Invoke-Build PublishPSGallery -ReleaseNotes 'First real release'</pre>

  * I use PowerShellGet for module installation in the configuration task. This necessitates PowerShell 5 as far as I know.
  * The root module files are my development files which are hosted in github. The release files are hosted in github as well. So someone can still simply pull the whole directory structure and install the module that way I suppose.
  * 

# Conclusion

This is probably enough for this article. I hope to refine this build script further as time permits. I hope others find some use from [PSModuleBuild][11]! There are more notes and caveats you can (and should) read over at the project page.

 [1]: https://github.com/nightroman/Invoke-Build/wiki
 [2]: https://github.com/shaynevanasperen/PowerTasks
 [3]: /wp-content/uploads/2016/07/clip_image001.png
 [4]: wp-content/uploads/2016/07/clip_image002.png
 [5]: wp-content/uploads/2016/07/clip_image003.png
 [6]: /wp-content/uploads/2016/07/clip_image004.png
 [7]: https://github.com/nightroman/Invoke-Build/issues/28
 [8]: https://bitbucket.org/splatteredbits/carbon/downloads
 [9]: http://www.red-gate.com/products/sql-development/sql-search/
 [10]: https://github.com/zloeber/FormatPowershellCode
 [11]: https://github.com/zloeber/PSModuleBuild