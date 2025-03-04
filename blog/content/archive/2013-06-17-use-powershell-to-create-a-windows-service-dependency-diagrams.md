---
title: Use Powershell to Create a Windows Service Dependency Diagrams
author: Zachary Loeber
type: post
date: 2013-06-17T15:32:42+00:00
excerpt: Use powershell with graphviz to generate color coded service dependency diagrams for windows services.
url: /blog/2013/06/17/use-powershell-to-create-a-windows-service-dependency-diagrams/
categories:
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Microsoft
  - network administration
  - Powershell
  - Scripting
  - Sysadmin
  - System Administration

---
I use powershell with graphviz to generate color coded service dependency diagrams for windows services. Besides creating useful and beautiful diagrams for your environment, this will also provide some interesting functions for gathering remote service information with alternate credentials.

<!--more-->

## Description

It seems like I come across something begging for a solution every day in my industry. For instance, I was working on performing a full dependency relationship table for services across my infrastructure and I got to thinking how cool it would be to have the ability to quickly create dependency diagrams for the services running on a server. Not finding anything free or simple, I whipped up a quick powershell script with a recursive function to utilize the built in cmdlets and return services, their dependencies, the dependencies of the dependencies, and so on. I then hacked this data into a template file for graphviz’s dot.exe diagram generation tool.

This probably should have been good enough but I wanted to also be able to do the same across multiple servers using alternate admin credentials. I found myself unrolling the solution into several sub-functions when get-service simply wasn’t filling my needs. This lead me to a better understanding of wmi and powershell functions in general. The end results are the following functions:

<p style="padding-left: 30px;">
  Get-RemoteService
</p>

<p style="padding-left: 30px;">
  Get-RemoteServiceDependency
</p>

<p style="padding-left: 30px;">
  Get-RemoteServiceDependencyTree
</p>

<p style="padding-left: 30px;">
  Get-RemoteRegistry (Not actually used in this script but included as a bonus!)
</p>

To actually generate the diagrams you will need graphviz’s dot.exe executable which can be downloaded and installed [here][1]. Or [here is a portable version][2] of the application you can try utilizing. All you need is for the dot.exe file to work correctly to generate your diagrams though. You may have to modify this script to use the appropriate path to the executable if you use the portable version of graphviz.

## Version

Version         :   1.0.0 June 16th 2013
  
&#8211; First release

## Notes

I included several functions in this exercise but I didn’t create any separate functions for the actual dot file generation. This is largely because there are so many ways this can be done. By default this script will create dependency diagrams which include hidden services in the dependency tree (as dashed nodes). This will also color code the nodes based on the status of the service.

The primary function you will use to create the dependency tree is the Get-RemoteServiceDependencyTree function. Here are three examples on how you might generate this data.

<pre># Example 1: Get the netlogon service locally 
$servicetree = @(Get-RemoteServiceDependencyTree -Name 'netlogon' -IsRootService $true)</pre>

<pre># Example 2: Get the netlogon service on the remote 'server1' prompting for credentials before connecting 
$servicetree = @(Get-RemoteServiceDependencyTree -Name 'netlogon' -IsRootService $true -ComputerName 'server1' -PromptForCredential)</pre>

<pre># Example 3: Get any service with "Exchange" in the name on a remote server called 'server1' 
$Cred = Get-Credential 
$servicetree = @(get-remoteservice -IncludeDriverServices $true -Credential $Cred -ComputerName 'server1' | where {$_.Name -like "*exchange*"} | Get-RemoteServiceDependencyTree -IsRootService $true -Credential $Cred -ComputerName 'server1')</pre>

<pre># This removes possible duplicate node connections and should be done for all examples 
$servicetree = $servicetree | Sort-Object ID –Unique</pre>

## Screenshots

Here is a diagram generated for the netlogon service (remotely to a test DC of mine for what it is worth).

[<img style="margin: 0px; display: inline; background-image: none;" title="clip_image002[1]" alt="clip_image002[1]" src="/wp-content/uploads/2013/06/clip_image0021_thumb.jpg?resize=244%2C78" width="244" height="78" border="0" data-recalc-dims="1" />][3]

Here is a more complex diagram depicting all of the services with “exchange” in the name on an exchange 2010 mailbox.

[<img style="margin: 5px; display: inline; background-image: none;" title="clip_image004[1]" alt="clip_image004[1]" src="/wp-content/uploads/2013/06/clip_image0041_thumb.jpg?resize=244%2C147" width="244" height="147" border="0" data-recalc-dims="1" />][4]

## Conclusion

This may be a good starting point for documentation of some of the essentials services running on your servers. Or if you are simply interested in to flow of service dependencies and need a good visual to understand them on your servers, this should certainly help you out.

## Downloads

[Download the script from the technet gallery (more frequently updated)][5]

[Download the script from this site (less frequently updated)][5]

 [1]: http://graphviz.org/
 [2]: https://code.google.com/p/graph-viz-portable/downloads/list
 [3]: /wp-content/uploads/2013/06/clip_image0021.jpg
 [4]: wp-content/uploads/2013/06/clip_image0041.jpg
 [5]: http://gallery.technet.microsoft.com/Use-Powershell-to-Create-a-ca883479