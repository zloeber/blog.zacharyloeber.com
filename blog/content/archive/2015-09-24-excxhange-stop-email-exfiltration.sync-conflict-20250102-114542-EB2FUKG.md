---
title: 'Exchange: Stop Email Exfiltration'
author: Zachary Loeber
type: post
date: 2015-09-25T01:41:25+00:00
url: /blog/2015/09/24/excxhange-stop-email-exfiltration/
categories:
  - Active Directory
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - Security
  - System Administration
tags:
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - network administration
  - Office 365
  - Powershell
  - System Administration

---
When your users leave or get removed from the organization they may still be getting company confidential information. Here is how you can find out and stop this from happening.

<!--more-->

I&#8217;ve seen this in numerous organizations so I figured I&#8217;d toss up a quick post and script for those who are interested in minimizing email exfiltration from occurring. Imagine this scenario:

  1. Bob from sales is going to be moving on from the organization. He has given his two weeks and is careful not to burn bridges on the way out (so he is not abruptly terminated).
  2. On his last day his AD account is disabled, password reset, and his activesync devices are removed and remote wiped.
  3. As an additional measure Bob&#8217;s AD account had all groups removed and was moved to a &#8216;Disabled&#8217; organizational unit.
  4. His replacement is delegated rights to access and manage his mailbox so they can respond to clients he may have been working with.
  5. Bob goes on to work for a competitor. Somehow Bob always seems to be able to reach out to and connect with prospective clients of yours that come in through an inquiry form on your website. He has managed to spear several large clients for his new employer because of this.

In the above example what is not said is that Bob setup some inbox rules in Outlook to forward a copy of any email received to another email account outside of the organization! Even if he was removed from all groups it wouldn&#8217;t matter if there were another inbox rule forwarding him the web inquiries (or even worse, if the web form just emailed a static list of users). This also doesn&#8217;t account for dynamic distribution lists which may be based on attributes  which are not cleared in the off-boarding process.

The gist of the issue is that email which should not be leaving the organization is flowing out to external sources. The quickest way to determine if this is something your organization suffers from is with a quick PowerShell Script.

<pre class="lang:powershell decode:true">function Get-MailboxForwardAndRedirectRules {
    &lt;#
    .SYNOPSIS
    Retrieves a list of mailbox rules which forward or redirect email elsewhere.
    .DESCRIPTION
    Retrieves a list of mailbox rules which forward or redirect email elsewhere.
    .PARAMETER MailboxNames
    Array of mailbox names in string format.    
    .PARAMETER MailboxObject
    One or more mailbox objects.
    .EXAMPLE
    Get-MailboxForwardAndRedirectRules -MailboxName "Test User1"
    
    Description
    -----------
    List test user1 forwarding and redirect rules.

    .EXAMPLE
    Get-Mailbox -ResultSize Unlimited | Get-MailboxForwardAndRedirectRules
    
    Description
    -----------
    List entire organization's inbox forwarding and redirecting rules.
    
    .LINK
    http://zacharyloeber.com
    .NOTES
    Last edit   :   11/04/2014
    Version     :   
    1.2.0 09/22/2015
    - Due to the moronic double pipeline limitations of Exchange 2010 I restructured the code
      to do all the processing in the end block (cause the process block is a pipeline after all...)
    - Added additional information to output (like AD disabled state and rule descriptions)
    1.1.0 11/04/2014
    - Minor structual changes and input parameter updates
    1.0.0 10/04/2014
    - Initial release
    Author      :   Zachary Loeber
    Original Author: https://gallery.technet.microsoft.com/PowerShell-Script-To-Get-0f1bb6a7/
    #&gt;
    [CmdLetBinding(DefaultParameterSetName='AsMailbox')]
    param(
        [Parameter(ParameterSetName='AsStringArray', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        [string[]]$MailboxNames,
        [Parameter(ParameterSetName='AsMailbox', Mandatory=$True, ValueFromPipeline=$True, Position=0, HelpMessage="Enter an Exchange mailbox name")]
        $MailboxObject
    )
    begin {
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin"
        $Mailboxes = @()
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AsStringArray' {
                try {
                    $Mailboxes = @($MailboxNames | Foreach {Get-Mailbox $_ -erroraction Stop})
                }
                catch {
                    Write-Warning = "$($FunctionName): $_.Exception.Message"
                }
            }
            'AsMailbox' {
               $Mailboxes += @($MailboxObject)
            }
        }
    }
    end {
        foreach ($Mailbox in $Mailboxes) {
            $UserInfo = Get-User $Mailbox.DistinguishedName 
            Write-Verbose "$($FunctionName): Checking $($Mailbox.Name)"
            Get-InboxRule -mailbox $Mailbox.DistinguishedName | Where {
                    ($_.forwardto -ne $null) -or 
                    ($_.redirectto -ne $null) -or 
                    ($_.ForwardAsAttachmentTo -ne $null) -and 
                    ($_.ForwardTo -notmatch "EX:/") -and 
                    ($_.RedirectTo -notmatch "EX:/") -and 
                    ($_.ForwardAsAttachmentTo -notmatch "EX:/")} | 
                Select @{n="Mailbox";e={($Mailbox.Name)}}, `
                       @{n="SAMAccountName";e={$UserInfo.SAMAccountName}}, `
                       @{n="ADAccountEnabled";e={-not ($UserInfo.UserAccountControl -match 'AccountDisabled')}}, `
                       @{n="DistinguishedName";e={($Mailbox.DistinguishedName)}}, `
                       @{n="RuleName";e={$_.name}}, `
                       @{n="Identity";e={$_.Identity}}, `
                       @{n="RuleEnabled";e={$_.Enabled}}, `
                       @{n="RuleDescription";e={$_.Description}}, `
                       @{Name="ForwardTo";Expression={[string]::join(";",($_.forwardTo))}}, `
                       @{Name="RedirectTo";Expression={[string]::join(";",($_.redirectTo))}}, `
                       @{Name="ForwardAsAttachmentTo";Expression={[string]::join(";",($_.ForwardAsAttachmentTo))}}
        }
        Write-Verbose "$($FunctionName): End"
    }
}</pre>

This should run on Exchange 2010/2013 and Office 365 (I&#8217;ve not tested for Exchange 2007). The results should provide everything you need to find out which disabled accounts are forwarding email outside of the organization with something like this:

<pre class="lang:powershell decode:true">Get-Mailbox -ResultSize Unlimited | Get-MailboxForwardAndRedirectRules | Export-CSV -NoTypeInformation 'Forwarding.csv'</pre>

Once inbox rules are found it is a simple matter of piping ones you want removed to Remove-InboxRule. I&#8217;ve posted this script [in my Github repo][1] some time ago but made some improvements recently. Anyway, It may be worth a few of your cycles to run this in your own environment to see if any wayward email is flowing out of your organization.

 [1]: https://github.com/zloeber/Powershell/blob/master/Exchange/Get-MailboxForwardAndRedirectRules.ps1