---
title: 'Powershell: Creating Plaster Manifest Files'
author: Zachary Loeber
type: post
date: 2017-05-15T17:49:48+00:00
url: /blog/2017/05/15/powershell-creating-plaster-manifest-files/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Microsoft
  - Powershell
  - Powershell Script
  - Scripting
  - Sysadmin
  - Windows

---
I&#8217;ve kicked the tires on a great PowerShell code scaffolding tool called &#8216;Plaster&#8217;. Here is my take on this nifty module.

<!--more-->

If any PowerShell nut tells you that you should turn absolutely everything into a module then either they are expert level PowerShell users or idealistic (or maybe both!). In either case, it is easier said than done. I was struggling with the idea of turning my [PSModuleBuild][1] project into a module as it just doesn&#8217;t really fit the module mentality in what it does. PSModuleBuild is really a set of scripts and a directory structure that serve as a template for a build pipeline for PowerShell module projects. This project is not module in its own right though.

Fast forward a bit and I found a write up putting PSModuleBuild side by side with a project I&#8217;ve heard of previously called [Plaster][2]. This intrigued me and so I decided to give Plaster a whirl. What I found was an extremely flexible scaffolding framework with an almost unwieldy xml manifest file back end calling the shots.

The general idea of Plaster goes something like this: Each Plaster template is a directory with a plastermanifest.xml file that determines what input (parameters) is required to create the output (content) from the files in that directory.

That being said, it should not be surprising that A Plaster xml manifest file is broken down into three parts;

  * General manifest details like author, version, and description
  * Parameter elements that are prompted for or provided at the command line (via dynamic parameters)
  * Content elements which are the directives for how the scaffold files are processed

While I can author xml with some level of proficiency, I thoroughly believe projects that tie themselves solely to xml suffer from a less robust adoption rate than those with simpler authoring methodologies. So in the spirit of open source I went ahead and submitted a pull request to add some functions to the project that pretty much take xml out of the picture. The functions are pretty simple and are able to be used separate from the module. As such I&#8217;m posting them here as well.

The gist of the additional functions is that you feed them arrays of hash tables that define either parameter or content elements. The parameter elements are exactly as you would expect, parameters to your Plaster manifest. They show up as prompts for data if you simply invoke the manifest with invoke-plaster. The content blocks are the rules that your plaster manifest follows after it has been fed all of the defined parameters. These content elements do various things like creating a new PowerShell module manifest files, copying files, displaying a message, or  transforming files. And these all can get a bit messy if you are manually authoring them in xml.

## Write-PlasterParameter

The parameter elements are pretty simplistic and I was able to get away with using one function for creating these. The content elements are far more complicated so I decided to split them up into a function for each content type with a wrapper function for calling them.

Here is a quick example of creating two parameters, one prompting for a Nuget API key and another that prompts for a choice.

<pre class="lang:powershell decode:true " title="Write-PlasterParameter Example">$MyParams = @(
@{
    ParameterName = "NugetAPIKey"
    ParameterType = "text"
    ParameterPrompt = "Enter a PowerShell Gallery (aka Nuget) API key. Without this you will not be able to upload your module to the Gallery"
    Default = ' '
},
@{
    ParameterName = "OptionAnalyzeCode"
    ParameterType = "choice"
    ParameterPrompt = "Use PSScriptAnalyzer in the module build process (Recommended for Gallery uploading)?"
    Default = "0"
    Store = "text"
    Choices = @(
        @{
            Label = "&Yes"
            Help = "Enable script analysis"
            Value = "True"
        },
        @{
            Label = "&No"
            Help = "Disable script analysis"
            Value = "False"
        }
    )
}) | Write-PlasterParameter</pre>

If you were to use this with the current version of Plaster you would have to create the plaster manifest with New-PlasterManifest then simply replace the &#8216;<parameters></parameters>&#8217; with the joined output of this function. The same goes for the content elements as well.

<pre class="lang:powershell decode:true" title="Updating a Plaster Manifest">$AllParams = '&lt;parameters&gt;' + ($MyParams -join '') + '&lt;/parameters&gt;'
(Get-Content C:\temp\plastermanifest.xml) -replace '&lt;parameters&gt;&lt;/parameters&gt;',$AllParams | Out-File C:\temp\plastermanifest.xml -encoding:utf8 -force
</pre>

**Note:** I&#8217;ve submitted a pull request for including the content and parameter sections as part of the new-plastermanifest command. There is an &#8216;IncludeContent&#8217; flag which is a bit different and includes xml files in the local directory in the content block (from what I could discern). Technically you could create the xml file manually for the content and then use this flag to include the content but I&#8217;ve not tested it out yet.

## Write-PlasterManifestContent

Currently there are a handful of supported content types. I&#8217;ve created a function for each of them and one big wrapper function for the lot of &#8217;em so you can do fancy things like the following to create a bunch of content elements:

<pre class="lang:powershell decode:true" title="Write-PlasterManifestContent">@(
    @{
        ContentType = 'newModuleManifest'
        Destination = '${PLASTER_PARAM_ModuleName}.psd1'
        moduleVersion = '${PLASTER_PARAM_ModuleVersion}'
        rootModule = '${PLASTER_PARAM_ModuleName}.psm1'
        copyright = '(c) ${PLASTER_Year} ${PLASTER_PARAM_ModuleAuthor}. All rights reserved.'
        projectURI = '${PLASTER_PARAM_ModuleWebsite}'
        licenseURI = '${PLASTER_PARAM_ModuleWebsite}/raw/master/license.md'
        iconURI = '${PLASTER_PARAM_ModuleWebsite}/raw/master/src/other/powershell-project.png'
        author = '${PLASTER_PARAM_ModuleAuthor}'
        companyname = '${PLASTER_PARAM_ModuleAuthor}'
        description = '${PLASTER_PARAM_ModuleDescription}'
        tags = '${PLASTER_PARAM_ModuleTags}'
        functionsToExport = '*'
        aliasesToExport = ''
        variablesToExport = ''
        encoding = 'UTF8-NoBOM'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\.gitignore'
        Destination = '.gitignore'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\.gitattributes'
        Destination = '.gitattributes'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\.vscode\*'
        Destination = '.vscode'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\other\*'
        Destination = 'src\${PLASTER_PARAM_OtherModuleSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\private\*'
        Destination = 'src\${PLASTER_PARAM_PrivateFunctionSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\public\*'
        Destination = 'src\${PLASTER_PARAM_PublicFunctionSource}'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\src\tests\*'
        Destination = 'src\tests'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\cleanup\*'
        Destination = 'build\cleanup'
    },
    @{
        ContentType = 'file'
        Source = 'scaffold\build\dotsource\*'
        Destination = 'build\dotsource'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\CreativeCommons.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "CreativeCommons"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\MIT.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "MIT"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\Apache.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "Apache"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\licenses\GPL.md'
        Destination = 'License.md'
        Condition = '$PLASTER_PARAM_ProjectLicense -eq "GPL"'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\ModuleName.psm1'
        Destination = '${PLASTER_PARAM_ModuleName}.psm1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\modulename.build.ps1'
        Destination = '${PLASTER_PARAM_ModuleName}.build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\modulename.buildenvironment.ps1'
        Destination = 'build\${PLASTER_PARAM_ModuleName}.buildenvironment.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\modulename.buildenvironment.json'
        Destination = 'build\${PLASTER_PARAM_ModuleName}.buildenvironment.json'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\readme.md'
        Destination = 'Readme.md'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Build.ps1'
        Destination = 'Build.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\Install.ps1'
        Destination = 'Install.ps1'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\EN-us\*'
        Destination = 'EN-us'
    },
    @{
        ContentType = 'templateFile'
        Source = 'scaffold\build\docs\index.md'
        Destination = 'build\docs\index.md'
    }
) | Write-PlasterManifestContent</pre>

As with the parameter block creation you will need to manually replace the &#8216;<content></content>&#8217; xml with the joined output of this function.

## Final Notes

The newModuleManifest content type in my helper function supports far more module manifest data than Plaster currently supports. I&#8217;ve put in a pull request for supporting the rest of the parameters that new-modulemanifest supports as well as supporting passing empty strings (which is nice if you want to create a new module manifest that doesn&#8217;t export every variable for instance).

I also have some changes that will directly accept parameter and content output from these functions in the new-plastermanifest command and am using all of this in my own project without any negative effects. But since they have not been approved/merged I&#8217;d not consider them official to the Plaster project in any way. As such, I&#8217;ve created [another personal branch for this project][3] that contains all my updates (as I wouldn&#8217;t have added them if I didn&#8217;t personally need them). You need only build it in vscode with CTRL+Shift+B (it is psake based) then use the module from the Releases directory.

Also the naming convention for the files in my repo is to follow that of the Plaster project.

## Links

[My Plaster Helper Functions][4]

[Official Plaster Project][2]

[Another article about using Plaster][5]

[Kevin Marquette&#8217;s GetPlastered Blog Article][6]

 [1]: https://github.com/zloeber/PSModuleBuild
 [2]: https://github.com/PowerShell/Plaster
 [3]: https://github.com/zloeber/Plaster/tree/pending-master
 [4]: https://github.com/zloeber/Powershell/tree/master/Plaster
 [5]: http://overpoweredshell.com/Working-with-Plaster/
 [6]: https://kevinmarquette.github.io/2017-05-14-Powershell-Plaster-GetPlastered-template/