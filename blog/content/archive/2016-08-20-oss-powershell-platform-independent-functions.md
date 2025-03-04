---
title: 'OSS PowerShell: Platform Independent Functions'
author: Zachary Loeber
type: post
date: 2016-08-21T03:41:03+00:00
url: /blog/2016/08/20/oss-powershell-platform-independent-functions/
categories:
  - Linux
  - Microsoft
  - OSSPosh
  - Powershell
tags:
  - Linux
  - OSS
  - OSSPosh
  - Powershell
  - Powershell Script
  - Scripting
  - Windows

---
Just the other day Microsoft released PowerShell as open source with builds available for Windows, Mac OSX, and a few flavors of Linux. I’m pretty certain the entire community is super hyped at the news. I know I am!

<!--more-->

I was able to quickly get PowerShell running on my Mint 17.3 (Rosa) workstation (Based on Ubuntu 14.04) in about 2 minutes flat [using the included documentation][1]. From here I was able to start up the shell and start using all the basic commands I’ve been using for years. But I soon realized that a large portion of my code would be useless on a Linux platform. The differences between Linux and Windows are pronounced enough that I can immediately list out some code that will cause compatibility issues. This includes:

  * Anything that references statically defined paths (think drive letters and such which do not exist on Linux)
  * Anything which relies on external DLLs
  * Anything which relies on WMI (generally is only on Windows and only targets Windows specific implementations of CIM/WBEM)
  * Most anything which uses Add-Type or other .NET type definitions. You will need to ensure compatibility with the .Net Core namespaces. There are [some tools for doing this][2] for more hardcore developers. You may have some luck by searching [here][3] for parts of your type definitions to see if it is available in .Net Core yet.
  * Pretty much anything &#8216;Windows-centric&#8217;. An example would be get-service. Yes, Linux and OSX has the concept of services/daemons but these are not the same as Windows services so Get-Service doesn’t work. I expect soon there will be wrapper functions available for SystemD (systemctl) and other service management frameworks but currently many of the native windows commands simply don’t work.

## Cross-Platform Functions

So how would you make a cross-platform capable function? That is a great question which you can gleam a bit of insight from simply by looking at the whopper of a [build script module included with OSSPosh][4] (my newly coined term for the project). Here is the first part of the module:

<pre class="lang:powershell decode:true "># Use the .NET Core APIs to determine the current platform; if a runtime
# exception is thrown, we are on FullCLR, not .NET Core.
try {
    $Runtime = [System.Runtime.InteropServices.RuntimeInformation]
    $OSPlatform = [System.Runtime.InteropServices.OSPlatform]

    $IsCoreCLR = $true
    $IsLinux = $Runtime::IsOSPlatform($OSPlatform::Linux)
    $IsOSX = $Runtime::IsOSPlatform($OSPlatform::OSX)
    $IsWindows = $Runtime::IsOSPlatform($OSPlatform::Windows)
} catch {
    # If these are already set, then they're read-only and we're done
    try {
        $IsCoreCLR = $false
        $IsLinux = $false
        $IsOSX = $false
        $IsWindows = $true
    }
    catch { }
}

if ($IsLinux) {
    $LinuxInfo = Get-Content /etc/os-release | ConvertFrom-StringData

    $IsUbuntu = $LinuxInfo.ID -match 'ubuntu'
    $IsUbuntu14 = $IsUbuntu -and $LinuxInfo.VERSION_ID -match '14.04'
    $IsUbuntu16 = $IsUbuntu -and $LinuxInfo.VERSION_ID -match '16.04'
    $IsCentOS = $LinuxInfo.ID -match 'centos' -and $LinuxInfo.VERSION_ID -match '7'
}</pre>

That looks pretty easy to use, so lets go ahead and do so! Here is a quick function to get things started. This function will let you know what platform you are running on.

<pre class="lang:powershell decode:true ">function Get-OSPlatform {
    # Parameter help description
    param(
        [Parameter()]
        [Switch]$IncludeLinuxDetails
    )
    try {
        $Runtime = [System.Runtime.InteropServices.RuntimeInformation]
        $OSPlatform = [System.Runtime.InteropServices.OSPlatform]

        $IsCoreCLR = $true
        $IsLinux = $Runtime::IsOSPlatform($OSPlatform::Linux)
        $IsOSX = $Runtime::IsOSPlatform($OSPlatform::OSX)
        $IsWindows = $Runtime::IsOSPlatform($OSPlatform::Windows)
    } 
    catch {
        # If these are already set, then they're read-only and we're done
        try {
            $IsCoreCLR = $false
            $IsLinux = $false
            $IsOSX = $false
            $IsWindows = $true
        }
        catch { }
    }

    if ($IsLinux) {
        if ($IncludeLinuxDetails) {
            $LinuxInfo = Get-Content /etc/os-release | ConvertFrom-StringData
            $IsUbuntu = $LinuxInfo.ID -match 'ubuntu'
            if ($IsUbuntu -and $LinuxInfo.VERSION_ID -match '14.04') {
                return 'Ubuntu 14.04'
            }
            if ($IsUbuntu -and $LinuxInfo.VERSION_ID -match '16.04') {
                return 'Ubuntu 16.04'
            }
            if ($LinuxInfo.ID -match 'centos' -and $LinuxInfo.VERSION_ID -match '7') {
                return 'CentOS'
            }
        }
        return 'Linux'
    }
    elseif ($IsOSX) {
        return 'OSX'
    }
    elseif ($IsWindows) {
        return 'Windows'
    }
    else {
        return 'Unknown'
    }
}</pre>

Here is how you might use the above function to write a generic function for getting the current IP address of the system you are on.

<pre class="lang:powershell decode:true ">function Get-PIIPAddress {
    switch ( Get-OSPlatform ) {
        'Linux' {
            $ipaddress = @([System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where {($_.OperationalStatus -eq 'Up')})
            ($ipaddress[0].Addresses | Where {$_.AddressFamily -eq 'InterNetwork'}).IPAddressToString
        }
        'OSX' {}
        Default {
            @(Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.DefaultIpGateway})[0].IPAddress[0]
        }
    } 
}</pre>

This is kind of a silly example but should get the point across. I&#8217;m essentially using two different methods to get the same information (a great improvement exercise for the reader would be to use the GetAllNetworkInterfaces first then filter based on name or something based on the platform and eliminate the Get-WMIObject entirely).

## Some Other Notes

If you want a quick Linux box of your own to try things out on here are my fast setup commands using vagrant with virtualbox (BTW, if you don&#8217;t already use chocolatey you can use this excellent app to get these two programs installed in record time on your workstation).

<pre class="lang:powershell decode:true ">mkdir C:\Vagrant
mkdir C:\Vagrant\Ubuntu
cd C:\Vagrant\Ubuntu
vagrant init ubuntu/xenial64
vagrant up
vagrant ssh

wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/powershell_6.0.0-alpha.9-1ubuntu1.16.04.1_amd64.deb
sudo apt-get install libunwind8 libicu55
sudo dpkg -i powershell_6.0.0-alpha.9-1ubuntu1.16.04.1_amd64.deb</pre>

I went ahead and installed OSSPosh (Or just PowerShell 6 if you prefer?) on my Windows 10 workstation as well. This installed quickly and without interfering with my current PowerShell profile or paths. You can quickly tell if you are in the Core or Desktop edition by taking a peek at the $PSEdition variable.

Interestingly enough the Powershell profile path is different. The desktop edition of Powershell (5.0) points where you would expect it to:

<pre class="lang:powershell decode:true">C:\Users\zloeber\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1</pre>

In the core version of PowerShell it points to a more platform agnostic path:

<pre class="lang:powershell decode:true">C:\Users\zloeber\Documents\PowerShell\Microsoft.PowerShell_profile.ps1</pre>

What I&#8217;m still trying to figure out is why the core edition loads different modules on my workstation than on my Linux box. There is a difference somewhere that I&#8217;ve yet to isolate but I&#8217;m sure will become clear soon enough.

## A Bug? (Update)

I&#8217;ve noticed a bug when using some native Linux commands from a Powershell console when connected to the host via SSH. It seems to hang the shell (or cause it to act sporadic and delayed). Currently aliases for ls, ps, and others are not set as the Posh team figures out the best way to go with this one. Simply setting some of these in the profile before loading the console seems to avert the issue for now. After connecting to your host via ssh do the following to create a profile script

<pre class="lang:powershell decode:true">mkdir ~/.config/powershell/
nano ~/.config/powershell/Microsoft.PowerShell_profile.ps1</pre>

Then add in a few aliases like so:

<pre class="lang:powershell decode:true">New-Alias -Name ls -Value 'Get-ChildItem'
New-Alias -Name ps -Value 'Get-Process'
</pre>

I&#8217;d use a tool like screen or tmux before loading the shell so you can kill it if things go wonky on you for whatever reason.

## Final Thoughts

I’m sure there are cleverer ways to get things like this done and I expect them to emerge in the coming months. Until then you may want to start thinking of modules you have written and seeing if they are good candidates for becoming cross-platform. This is exciting times for us cross-platform geeks. We are getting bash on Windows, Powershell on Linux, what next? I don’t know but I’m looking forward to seeing where things go!

 [1]: https://github.com/powershell/powershell
 [2]: https://github.com/dotnet/corefx/blob/master/Documentation/project-docs/support-dotnet-core-instructions.md
 [3]: http://packagesearch.azurewebsites.net/
 [4]: https://github.com/PowerShell/PowerShell/blob/master/build.psm1