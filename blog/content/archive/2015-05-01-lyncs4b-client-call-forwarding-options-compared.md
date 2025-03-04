---
title: 'Lync/S4B Client: Call Forwarding Options Compared'
author: Zachary Loeber
type: post
date: 2015-05-01T19:00:48+00:00
url: /blog/2015/05/01/lyncs4b-client-call-forwarding-options-compared/
categories:
  - Lync
  - Microsoft
  - Skype For Business
  - System Administration
tags:
  - Lync
  - Lync 2013
  - Microsoft
  - PSC
  - S4B
  - Skype For Business
  - System Administration

---
Here is a comparison chart I put together describing the different call forwarding options available to end users or their teams. This covers everything which can be setup by users in Lync as well as team calling (setup by the admin).

<!--more-->

When an end user comes to you and asks that a number be forwarded or picked up on other phones you have a few options. Yes, you can start looking at complicated response group configurations but many times you do not need something quite that involved. You also have the option of setting up delegation, call groups, team calls, and simultaneous ring destinations.

Many of these options are accessed directly in the Skype for Business client in the lower left corner:

[<img style="margin: 5px; display: inline; background-image: none;" title="image" src="/wp-content/uploads/2015/05/image_thumb.png?resize=287%2C162" alt="image" width="287" height="162" border="0" data-recalc-dims="1" />][1]

Here is a little bit of condensed data around these options you can use when making your selection or helping others in how they choose to forward their calls:

<table style="height: 147px;" width="460">
  <tr>
    <td>
    </td>
    
    <td>
      <strong>Simultaneous Ring</strong>
    </td>
    
    <td>
      <strong>Delegate &#8211; Simultaneous Ring</strong>
    </td>
    
    <td>
      <strong>Delegate &#8211; Forward my calls to</strong>
    </td>
    
    <td width="116">
      <strong>Group Call Pickup</strong>
    </td>
    
    <td width="93">
      <strong>Team Call</strong>
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Called user can see who has answered the call</strong>
    </td>
    
    <td>
      FALSE
    </td>
    
    <td>
      FALSE
    </td>
    
    <td>
      FALSE
    </td>
    
    <td width="116">
      TRUE
    </td>
    
    <td width="93">
      TRUE
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Endpoints that ring</strong>
    </td>
    
    <td>
      All Endpoints
    </td>
    
    <td>
      All Endpoints
    </td>
    
    <td>
      Delegate Endpoints Only
    </td>
    
    <td width="116">
      Only Called User Endpoints
    </td>
    
    <td width="93">
      All Endpoints
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Call displayed as original inbound caller</strong>
    </td>
    
    <td>
      TRUE
    </td>
    
    <td>
      FALSE
    </td>
    
    <td>
      FALSE
    </td>
    
    <td width="116">
      NA
    </td>
    
    <td width="93">
      FALSE
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Call displayed as user being dialed</strong>
    </td>
    
    <td>
      FALSE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td width="116">
      NA
    </td>
    
    <td width="93">
      TRUE
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Can be configured by end users</strong>
    </td>
    
    <td>
      TRUE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td width="116">
      FALSE
    </td>
    
    <td width="93">
      TRUE
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>Can make call on behalf of called user</strong>
    </td>
    
    <td>
      FALSE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td>
      TRUE
    </td>
    
    <td width="116">
      FALSE
    </td>
    
    <td width="93">
      FALSE
    </td>
  </tr>
</table>

&nbsp;

Here is the prettier excel version of &#8216;[Lync &#8211; Ring Options][2]&#8216; with the same information for your convenience.

 [1]: wp-content/uploads/2015/05/image.png
 [2]: /wp-content/uploads/2015/05/Lync-Ring-Options.xlsx