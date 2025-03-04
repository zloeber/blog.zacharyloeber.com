---
title: 'PowerShell: Thoughts on Module Design'
author: Zachary Loeber
type: post
date: 2015-10-03T18:57:04+00:00
url: /blog/2015/10/03/powershell-thoughts-on-module-design/
categories:
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Microsoft
  - Powershell
  - Sysadmin
  - System Administration
  - Windows

---
I&#8217;ve finally decided to grow up and start making modules out of my rather large PowerShell code base. Here are a few things I&#8217;ve learned.

<!--more-->

## Introduction

Initially I avoided creating modules simply because I was uncomfortable creating them and felt they were needless overhead to me getting scripts out the door. I also had the misconception that modules needed to be installed on a host system to be used. This misconception went against my personal mantra of built in portability.

I know now that I was limiting myself with this mindset. Now I&#8217;m rounding back and and catching up to the rest of the civilized PowerShell coder world. Here is how I settled on coding my modules for now, I&#8217;m sure this will evolve as my skills and experience grow but this should be a good base for anyone else delving into getting more modular with their PowerShell scripts.

## Module Structure

The basic structure I&#8217;ve settled on is as follows:

  * ModuleName 
      * en-US\
      * src\ 
          * public\
          * private\
      * lib\
      * bin\
      * build\
      * test\
  
        ModuleName.Format.ps1xml
  
        ModuleName.psd1
  
        ModuleName.psm1
  
        Install.ps1

Looking at examples and a few other PowerShell module articles ([here][1] and [here][2] and [here][3]) I came to realize it would be wise to keep all functions as separate files. This can be a pain when debugging and testing if you have multiple dependencies between functions in your project. But for overall maintainability and simplicity a divide and conquer approach is preferred. This has the benefit of not having to deal with manual changes every time you include or remove a function from being exported as a module command. This is why the src directory has both public and private directories. Any ps1 files in the private folder will be dot sourced and kept private within the module. Any ps1 files within the public directory will be dot sourced, then any first level functions found will be exported and exposed for general use.

My ModuleName.psm1 base file becomes pretty simple and can be used for most modules without any modification.

<pre class="lang:powershell decode:true ">#region Private Variables
# Current script path
[string]$ScriptPath = Split-Path (get-variable myinvocation -scope script).value.Mycommand.Definition -Parent
#endregion Private Variables

#region Methods

# Dot sourcing private script files
Get-ChildItem $ScriptPath/src/private -Recurse -Filter "*.ps1" -File | Foreach { 
    . $_.FullName
}

# Load and export methods

# Dot sourcing public function files
Get-ChildItem $ScriptPath/src/public -Recurse -Filter "*.ps1" -File | Foreach { 
    . $_.FullName

    # Find all the functions defined no deeper than the first level deep and export it.
    # This looks ugly but allows us to not keep any uneeded variables from poluting the module.
    ([System.Management.Automation.Language.Parser]::ParseInput((Get-Content -Path $_.FullName -Raw), [ref]$null, [ref]$null)).FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | Foreach {
        Export-ModuleMember $_.Name
    }
}
#endregion Methods

#region Module Cleanup
$ExecutionContext.SessionState.Module.OnRemove = {
    # cleanup when unloading module (if any)
}
#endregion Module Cleanup</pre>

As you can see I use AST to find all the first level function names and export them for public consumption. Additionally, if I&#8217;m wanting to keep a template or other ps1 files around there is no harm in leaving them either at the root of the src directory or in any other named sub-directory. The entire module directory is self containing as well so we can copy it anywhere and import the psm1 file directly.

## Installing

Speaking of installing things I do include a fairly generic Install.ps1 file which can be called in a single line to actually install the module if people want to do so. It is easily modified for any other module or upload location if you aren&#8217;t using Github.

<pre class="lang:powershell decode:true"># Run this in an administrative PowerShell prompt to install the EWSModule PowerShell module:
#
# 	iex (New-Object Net.WebClient).DownloadString("https://github.com/zloeber/EWSModule/raw/master/Install.ps1")

# Some general variables
$ModuleName = 'EWSModule'	# Example: mymodule
$GithubURL = 'https://github.com/zloeber/EWSModule'	# Example: https://www.github.com/zloeber/mymodule

# Download and install the module
$webclient = New-Object System.Net.WebClient
$url = "$GithubURL/archive/master.zip"
Write-Host "Downloading latest version of EWSModule from $url" -ForegroundColor Cyan
$file = "$($env:TEMP)\$($ModuleName).zip"
$webclient.DownloadFile($url,$file)
Write-Host "File saved to $file" -ForegroundColor Green
$targetondisk = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"
New-Item -ItemType Directory -Force -Path $targetondisk | out-null
$shell_app=new-object -com shell.application
$zip_file = $shell_app.namespace($file)
Write-Host "Uncompressing the Zip file to $($targetondisk)" -ForegroundColor Cyan
$destination = $shell_app.namespace($targetondisk)
$destination.Copyhere($zip_file.items(), 0x10)
Write-Host "Renaming folder" -ForegroundColor Cyan
if (Test-Path "$targetondisk\$($ModuleName)") { Remove-Item -Force "$targetondisk\$($ModuleName)" -Confirm:$false }
Rename-Item -Path ($targetondisk+"\$($ModuleName)-master") -NewName "$ModuleName" -Force
Write-Host "Module has been installed" -ForegroundColor Green
Write-Host "You can now import the module with: Import-Module -Name $ModuleName"</pre>

The one-liner at the top directs the user to download the Install.ps1 file and automatically run it. The script downloads, then unzips the module to a temporary location, deletes any existing module folder with the same name (after prompting of course), then copies the downloaded and extracted module folder to the user profile Modules directory.

## Other Directories

The other directories are not as important but are kind of placeholders for things. The test directory will be for pester tests (which I&#8217;ve yet to implement but hope to do so soon). The build directory will be for more complex projects and should be ignored in your .gitignore file. Lib and bin are for dlls and exes respectively if you have need for them.

## Conclusion

That&#8217;s just about it really. I&#8217;ve a script out there to build some of this but it is in such a basic form that it isn&#8217;t worth pointing out. There are some pretty good but rarely mentioned module build tools out there on github you can take a peek at though.

Here are some I was looking at either using or stealing ideas from 🙂

<p style="margin: 0in; font-family: Calibri; font-size: 11.0pt;">
  <strong>Project:</strong> PmBuild (<a href="https://github.com/brianaddicks/PmBuild">https://github.com/brianaddicks/PmBuild</a>)
</p>

**Description:** PmBuild is a PowerShell module that provides tools for combing powershell functions into a single psm1 module file, as well as documenting said cmdlets based on their get-help information.

**Project:** ModuleBuilder (<https://github.com/PoshCode/ModuleBuilder>)

**Description:** The primary goal of this module is to increase the ease and consistency of PowerShell module creation as well as provide a structure to the project that makes it easy for others to contribute and for the owners to integrate those changes in.

 [1]: http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
 [2]: http://devblackops.io/designing-your-powershell-module-for-maintainability/
 [3]: http://joshua.poehls.me/powershell-script-module-boilerplate/