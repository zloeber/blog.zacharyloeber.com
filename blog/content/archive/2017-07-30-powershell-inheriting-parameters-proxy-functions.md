---
title: 'PowerShell: Inheriting Parameters (Proxy Functions)'
author: Zachary Loeber
type: post
date: 2017-07-30T14:23:36+00:00
url: /blog/2017/07/30/powershell-inheriting-parameters-proxy-functions/
categories:
  - Powershell
tags:
  - Powershell
  - Powershell Script
  - Scripting

---
If you want one function to have all the parameters of another function here is one method you could use.

<!--more-->

# What?

This may seem like a bit of an odd topic. But hear me out as there are some interesting use cases to for wanting to pull in all the parameters from one function for use in another. I’d call this a ‘proxy function’ but it is more useful than that. Let me explain.

# My ‘Use Case’

Consider querying Active Directory with ADSI (none of that sissy ActiveDirectory module stuff). What are the differences between searching for a user versus a computer? Mostly the difference is a bit of LDAP filter trickery. And if you think about it, you only have one type of real query for a good many things in AD, that for AD objects. The LDAP filters, search base, scope, credentials, and other aspects of the ADSI searcher may differ but the general idea is the same.

So logically, if I were to break down the functions for creating a function for searching for a user in AD it might look something like this:

<div id="attachment_1744" style="width: 310px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2017/07/ADSISearcher.jpg"><img class="size-medium wp-image-1744" src="/wp-content/uploads/2017/07/ADSISearcher.jpg?resize=300%2C163" alt="" width="300" height="163" srcset="/wp-content/uploads/2017/07/ADSISearcher.jpg?resize=300%2C163 300w, /wp-content/uploads/2017/07/ADSISearcher.jpg?w=346 346w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Finding a User via ADSI
  </p>
</div>

If you wanted to support all of the different ways you could connect to AD along with all of the different ADSI searcher options you end up with a bunch of parameters that you would have to deal with passing through the chain of functions. My Get-DSObject function parameter block is a beast, check it out..

<pre class="font:ubuntu-mono lang:powershell decode:true " title="Get-DSObject Parameter Block">param(
        [Parameter( position = 0 , ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage='Object to retreive. Accepts distinguishedname, GUID, and samAccountName.')]
        [Alias('User', 'Name', 'sAMAccountName', 'distinguishedName')]
        [string]$Identity,

        [Parameter( position = 1, HelpMessage='Domain controller to use for this search.' )]
        [Alias('Server','ServerName')]
        [string]$ComputerName = $Script:CurrentServer,

        [Parameter(HelpMessage='Credentials to connect with.' )]
        [alias('Creds')]
        [Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential = $Script:CurrentCredential,

        [Parameter(HelpMessage='Limit results. If zero there is no limit.')]
        [Alias('SizeLimit')]
        [int]$Limit = 0,

        [Parameter(HelpMessage='Root path to search.')]
        [string]$SearchRoot,

        [Parameter(HelpMessage='LDAP filters to use.')]
        [string[]]$Filter,

        [Parameter(HelpMessage='Immutable base ldap filter to use.')]
        [string]$BaseFilter,

        [Parameter(HelpMessage='LDAP properties to return')]
        [string[]]$Properties = @('Name','ADSPath'),

        [Parameter(HelpMessage='Page size for larger results.')]
        [int]$PageSize = $Script:PageSize,

        [Parameter(HelpMessage='Type of search.')]
        [ValidateSet('Subtree', 'OneLevel', 'Base')]
        [string]$SearchScope = 'Subtree',

        [Parameter(HelpMessage='Security mask for search.')]
        [ValidateSet('None', 'Dacl', 'Group', 'Owner', 'Sacl')]
        [string]$SecurityMask = 'None',

        [Parameter(HelpMessage='Include tombstone objects.')]
        [switch]$TombStone,

        [Parameter(HelpMessage='Use logical OR instead of AND for custom LDAP filters.')]
        [switch]$ChangeLogicOrder,

        [Parameter(HelpMessage='Only include objects modified after this date.')]
        [datetime]$ModifiedAfter,

        [Parameter(HelpMessage='Only include objects modified before this date.')]
        [datetime]$ModifiedBefore,

        [Parameter(HelpMessage='Only include objects created after this date.')]
        [datetime]$CreatedAfter,

        [Parameter(HelpMessage='Only include objects created before this date.')]
        [datetime]$CreatedBefore,

        [Parameter(HelpMessage='Do not joine attribute values in output.')]
        [switch]$DontJoinAttributeValues,

        [Parameter(HelpMessage='Include all properties that have a value')]
        [switch]$IncludeAllProperties,

        [Parameter(HelpMessage='Include null property values')]
        [switch]$IncludeNullProperties,

        [Parameter(HelpMessage='Expand useraccountcontroll property (if it exists).')]
        [switch]$ExpandUAC,

        [Parameter(HelpMessage='Do no property transformations in output.')]
        [switch]$Raw,

        [Parameter(HelpMessage='How you want the results to be returned.')]
        [ValidateSet('psobject', 'directoryentry', 'searcher')]
        [string]$ResultsAs = 'psobject'
    )</pre>

Blech!

That would be a ton of parameters to repeat over and over again for minor query differences and logic nuances for different functions for finding computers, users, groups, or group members (just to name a few). So how can I create one set of base parameters and inherit them by the functions that will be quasi-wrapping around the same Get-DSObject function I’ll be using?

> **Note:** I&#8217;ll not go into classes and object inheritance here as I&#8217;m almost certain that in a more fully featured language like C# you could do this with much more elegant techniques.

# Clever Dynamic Parameters

Dynamic parameters can be tricky and have some nuances that make them less than ideal for a good many things. But in this case they are exceedingly useful. To construct all the parameters of Get-DSObject as part of a parameter block of another function I use a function I found in [SnippetPX][1].

<pre class="font:ubuntu-mono lang:powershell decode:true" title="New-ProxyFunction">Function New-ProxyFunction {
    &lt;#
    .SYNOPSIS
        Proxy function dynamic parameter block
    .DESCRIPTION
        The dynamic parameter block of a proxy function. This block can be used to copy a proxy function target's parameters, regardless of changes from version to version.
    #&gt;
    [System.Diagnostics.DebuggerStepThrough()]
    param(
        # The name of the command being proxied.
        [System.String]
        $CommandName,

        # The type of the command being proxied. Valid values include 'Cmdlet' or 'Function'.
        [System.Management.Automation.CommandTypes]
        $CommandType
    )
    try {
        # Look up the command being proxied.
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand($CommandName, $CommandType)

        #If the command was not found, throw an appropriate command not found exception.
        if (-not $wrappedCmd) {
            $PSCmdlet.ThrowCommandNotFoundError($CommandName, $PSCmdlet.MyInvocation.MyCommand.Name)
        }

        # Lookup the command metadata.
        $metadata = New-Object -TypeName System.Management.Automation.CommandMetadata -ArgumentList $wrappedCmd

        # Create dynamic parameters, one for each parameter on the command being proxied.
        $dynamicDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        foreach ($key in $metadata.Parameters.Keys) {
            $parameter = $metadata.Parameters[$key]
            $dynamicParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @(
                $parameter.Name
                $parameter.ParameterType
                ,$parameter.Attributes
            )
            $dynamicDictionary.Add($parameter.Name, $dynamicParameter)
        }
        $dynamicDictionary

    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}</pre>

This pulls in the already loaded function (or cmdlet) then using the metadata for that command, it generates brand new runtimedefinedparameter objects that mirror those of the passed function/cmdlet. This is exactly what we need to emit from our DynamicParam block!

Using this function in the dynamic parameter block of another function looks something like this for one of my easier examples:

<pre class="font:ubuntu-mono lang:powershell decode:true" title="Get-DSGroupMember">function Get-DSGroupMember {
    &lt;#
    .SYNOPSIS
    Return all members of a group.
    .DESCRIPTION
    Return all members of a group.
    .PARAMETER Recurse
    Return all members of a group, even if they are in another group.
    .EXAMPLE
    PS&gt; Get-DSGroupMember -Identity 'Domain Admins' -recurse -Properties *

    Retrieves all domain admin group members, including those within embedded groups along with all their properties.
    .NOTES
    Author: Zachary Loeber
    .LINK
    https://github.com/zloeber/PSAD
    #&gt;
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [Parameter()]
        [switch]$Recurse
    )

    DynamicParam {
        # Create dictionary
        New-ProxyFunction -CommandName 'Get-DSObject' -CommandType 'Function'
    }

    begin {
        # Function initialization
        if ($Script:ThisModuleLoaded) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }

        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."

        $Identities = @()
    }

    process {

        # Pull in all the dynamic parameters (generated from get-dsobject)
        # as we might have values via pipeline we need to do this in the process block.
        if ($PSBoundParameters.Count -gt 0) {
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters
        }

        # Create a splat with only Get-DSObject parameters
        $GetObjectParams = @{}
        $PSBoundParameters.Keys | Where-Object { ($Script:GetDSObjectParameters -contains $_) } | Foreach-Object {
            $GetObjectParams.$_ = $PSBoundParameters.$_
        }

        # Store another copy of the splat for later member lookup
        $GetMemberParams = $GetObjectParams.Clone()
        $GetMemberParams.Identity = $null

        $Identities += $Identity
    }

    end {
        Foreach ($ID in $Identities) {
            Write-Verbose "$($FunctionName): Searching for group: $ID"
            $GetObjectParams.Identity = $ID
            $GetObjectParams.Properties = 'distinguishedname'

            try {
                $GroupDN = (Get-DSGroup @GetObjectParams).distinguishedname
                if ($Recurse) {
                    $GetMemberParams.BaseFilter += "memberof:1.2.840.113556.1.4.1941:=$GroupDN"
                }
                else {
                    $GetMemberParams.BaseFilter += "memberof=$GroupDN"
                }

                Get-DSObject @GetMemberParams
            }
            catch {
                Write-Warning "$($FunctionName): Unable to find group with ID of $ID"
            }
        }
    }
}
</pre>

If you were to look at the comment based help and parameter block code that I&#8217;m not having to include in this function by using this method I save over 200 lines of code. This adds up VERY quickly.

You can see in this code that I don’t have to include a ton of other parameters to make the whole thing work. But I do have to do a few other things if I want pipeline variables to work and for PlatyPS to recognize and populate parameter help text later on when I create a module. Firstly, we need to disable positional binding. Otherwise the Identity parameter that we would want to pipeline as position 0 will not work as intended.

<pre class="font:ubuntu-mono lang:powershell decode:true">[CmdletBinding(PositionalBinding=$false)]</pre>

> **Note:** This doesn&#8217;t disable positional binding entirely, any parameter that has a position manually defined will still work. Our proxied function has them manually defined for this very reason.

Additionally, comment based help doesn&#8217;t help you out a lick when using dynamic parameters. But since the new-proxyfunction retains any helpmessage text in the original parameter definitions, PlatyPS will still generate the appropriate module documentation later on. This is why we include the help text in the original function  (get-dsobject).

For recreating the parameter splat for the original function you will see I reference a variable that is simply an array for all the parameters for that function.

<pre class="font:ubuntu-mono lang:powershell decode:true"># Create a splat with only Get-DSObject parameters
        $GetObjectParams = @{}
        $PSBoundParameters.Keys | Where-Object { ($Script:GetDSObjectParameters -contains $_) } | Foreach-Object {
            $GetObjectParams.$_ = $PSBoundParameters.$_
        }</pre>

I pre-generate this array ahead of time in my module to eek out a little bit of performance. This could have been pre-generated in the begin block though. Here is the function to grab the parameters for a function:

<pre class="font:ubuntu-mono lang:powershell decode:true " title="Get-CommandParams">Function Get-CommandParams {
    &lt;#
    .SYNOPSIS
        Get available parameters for a command.
    .DESCRIPTION
        Get available parameters for a command. This skips default parameters.
    #&gt;
    [System.Diagnostics.DebuggerStepThrough()]
    param(
        # The name of the command being proxied.
        [System.String]
        $CommandName,

        # The type of the command being proxied. Valid values include 'Cmdlet' or 'Function'.
        [System.Management.Automation.CommandTypes]
        $CommandType
    )
    try {
        # Look up the command being proxied.
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand($CommandName, $CommandType)

        #If the command was not found, throw an appropriate command not found exception.
        if (-not $wrappedCmd) {
            $PSCmdlet.ThrowCommandNotFoundError($CommandName, $PSCmdlet.MyInvocation.MyCommand.Name)
        }

        # Lookup the command metadata.
        (New-Object -TypeName System.Management.Automation.CommandMetadata -ArgumentList $wrappedCmd).Parameters.Keys
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}</pre>

I also use [New-DynamicParameter][2] for one very small part of this function, to create the local variables for each parameter that gets passed that is a dynamic parameter. This function can be used for a whole lot more and is highly recommended for more advanced dynamicparam blocks.

<pre class="font:ubuntu-mono lang:powershell decode:true "># Pull in all the dynamic parameters (generated from get-dsobject)
# as we might have values via pipeline we need to do this in the process block.
if ($PSBoundParameters.Count -gt 0) {
    New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters
}</pre>

# Conclusion

I wrote this article to point out a technique I started using. I also put this out there half hoping that someone will point me out to a better, more clever, way of accomplishing this kind of task in PowerShell. If you have something in mind that invalidates this entire post I&#8217;d love to hear about it 🙂 If you are at all interested in the project I&#8217;m putting together that inspired this post you can [check it out here][3]. It isn&#8217;t fully realized yet but it does have a pretty large code base worth tinkering with.

 [1]: https://github.com/KirkMunro/SnippetPx
 [2]: https://github.com/beatcracker/Powershell-Misc/blob/master/New-DynamicParameter.ps1
 [3]: https://github.com/zloeber/PSAD