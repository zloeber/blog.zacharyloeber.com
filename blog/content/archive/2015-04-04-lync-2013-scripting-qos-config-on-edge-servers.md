---
title: 'Lync 2013: Scripting QoS Config on Edge Servers'
author: Zachary Loeber
type: post
date: 2015-04-04T21:41:51+00:00
url: /blog/2015/04/04/lync-2013-scripting-qos-config-on-edge-servers/
categories:
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Lync
  - Lync 2013
  - Lync Server 2013
  - Lync Voice
  - Microsoft
  - Powershell
  - PSC
  - Windows

---
In many environments the Lync 2013 edge servers are configured in a standalone workgroup without any easy method for setting standard policies (such as GPOs). To make QoS configuration a bit less manual and error prone I&#8217;ve put together this script which can be run in an administrative powershell prompt. It will update the NLA setting (or create it if it doesn&#8217;t already exist), backup and prompt for removal any existing Qos settings, then import the registry settings for Audio, Video, and App QoS settings as defined in the script parameters.

<!--more-->

## Details

QoS settings in Windows are simply registry keys with some values underneath. All this script does behind the scenes is create a .reg file based on a template and imports it. The default settings are fairly standard but are also easy to change to suit your needs or environment. Although the current QoS settings are displayed and exported to a backup .reg file I still recommend caution when running this script in your production environment.

Here is the obligatory comment based help for the script:

<pre class="lang:powershell decode:true">&lt;# 
.SYNOPSIS 
Sets Qos configuration on Lync edge servers quickly. 
.DESCRIPTION 
Sets Qos configuration on Lync edge servers quickly. This is meant to be run locally at each edge server. 
.PARAMETER AudioPortStart 
Audio Qos port start. Default value is 49152 
.PARAMETER AudioPortEnd 
Audio Qos port End. Default value is 57500 
.PARAMETER AudioDSCP 
Audio Qos DSCP value. Default value is 46 
.PARAMETER VideoPortStart 
Video Qos port start. Default value is 57501 
.PARAMETER VideoPortEnd 
Video Qos port start. Default value is 65535 
.PARAMETER VideoDSCP 
Video Qos DSCP value. Default value is 32  
.PARAMETER AppPortStart 
App Qos port start. Default value is 40803 
.PARAMETER AppPortEnd 
App Qos port start. Default value is 48837 
.PARAMETER AppDSCP 
App Qos DSCP value. Default value is 0 
.EXAMPLE 
PS &gt; Set-LyncEdgeQos 
 
Description 
----------- 
Sets the egde server Qos values to the defaults defined in the script parameters then displays them.  
 
The default values will look something like this when used: 
 
    Policy            : Lync App Sharing 
    Local Ports       : * 
    Local Port Begin  : NA 
    Local Port End    : NA 
    Local Port Count  : NA 
    Remote Ports      : 40803:48837 
    Remote Port Begin : 40803 
    Remote Port End   : 48837 
    Remote Port Count : 8034 
    DSCP Value        : 0 
 
    Policy            : Lync Audio 
    Local Ports       : * 
    Local Port Begin  : NA 
    Local Port End    : NA 
    Local Port Count  : NA 
    Remote Ports      : 49152:57500 
    Remote Port Begin : 49152 
    Remote Port End   : 57500 
    Remote Port Count : 8348 
    DSCP Value        : 46 
 
    Policy            : Lync Video 
    Local Ports       : * 
    Local Port Begin  : NA 
    Local Port End    : NA 
    Local Port Count  : NA 
    Remote Ports      : 57501:65535 
    Remote Port Begin : 57501 
    Remote Port End   : 65535 
    Remote Port Count : 8034 
    DSCP Value        : 32 
.NOTES 
Author: Zachary Loeber 
 
Requires: Powershell 3.0 
 
Version History 
1.0.0 - 03/31/2015 
- Initial release 
#&gt;</pre>

As usual, the script has been uploaded to the [Microsoft technet gallary][1] and [my github repo][2].

 [1]: https://gallery.technet.microsoft.com/Lync-2013-Set-Local-Server-724655df
 [2]: https://github.com/zloeber/Powershell/blob/master/Lync/Set-LyncEdgeQos.ps1