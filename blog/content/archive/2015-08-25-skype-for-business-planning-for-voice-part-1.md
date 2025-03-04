---
title: 'Skype For Business: Planning for Voice – Part 1'
author: Zachary Loeber
type: post
date: 2015-08-25T07:47:39+00:00
url: /blog/2015/08/25/skype-for-business-planning-for-voice-part-1/
categories:
  - Exchange 2013
  - Lync
  - Microsoft
  - Skype For Business
tags:
  - Enterprise Voice
  - Exchange 2013
  - Lync 2013
  - Lync Server 2013
  - Lync Voice
  - PBX
  - PSC
  - Skype For Business
  - VoIP

---
When planning for a full Skype for Business voice deployment there are a number of elements which should be aligned and setup properly for a smooth transition. This is an introduction article for a series where I’ll provide some insight on what info you need to collect and understand for a successful PBX replacement within your organization.

<!--more-->

Deploying any PBX replacement can be a daunting task and Skype for Business is no exception. There are the many moving parts to consider in your plans. This includes (but is not limited to) the Skype for Business and Exchange server architecture and deployment, current WAN and PSTN site local infrastructure readiness, and devices to select and deploy for the end users. There are many guides out there for deploying and designing your servers and even on selecting your devices but one aspect of a deployment that I don’t see covered quite well enough is the actual PBX assessment and replacement on a per site basis. I’m hoping fill this gap a bit with some tools, checklists, and tips that I’ve put together.

I&#8217;ll be upfront and state I believe much of this information is PBX agnostic and can be applicable for _**any**_ phone system upgrade. But I do target Skype for Business though so you may want to bone up on your nomenclature. Instead of reinventing the wheel I&#8217;ll point you out to another [excellent set of articles][1] by Jonathan McKinney that I consider not so hidden gems of knowledge that everyone should have when deploying Lync/Skype for Business as a PBX.

## Introduction

If you have made it this far then great! That means you have more than just a passing interest in taking the next steps of what can be a difficult but rewarding process for your organization. These rewards go beyond simply removing an old (and often failing) PBX gone from your life as well. There are real and tangible cost savings to be had in undergoing this process, sometimes in areas which may surprise you. Simply going through the discovery process may bring to light expensive PSTN lines which are not in use, nonsensical dial plans, or ridiculous processes people undertake (like faxing between offices).

[<img class="aligncenter size-medium wp-image-1497" src="/wp-content/uploads/2015/07/PSTNProvider_Tax.jpg?resize=300%2C300" alt="PSTNProvider_Tax" width="300" height="300" srcset="/wp-content/uploads/2015/07/PSTNProvider_Tax.jpg?resize=300%2C300 300w, wp-content/uploads/2015/07/PSTNProvider_Tax.jpg?resize=150%2C150 150w, wp-content/uploads/2015/07/PSTNProvider_Tax.jpg?w=400 400w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]

Unsurprisingly, there are multiple phases to a Skype for Business and Exchange based unified messaging deployment before you ever get to the point of deploying enterprise voice though. Lets go the overarching deployment phases for the entire organization in this first article. This is primarily focused around on premise deployments but generally holds true for Office 365 hybrid as well (where Phase 1 and 2 are kind of merged).

## Phase 1 – Internal IM and Presence

This phase includes deploying the Skype for Business client to end user workstations and devices for internal or VPN connected end users. In phase 1 the active directory environment is prepped and internal Skype for Business front end pools are created. SIP domains are determined and then used used to create a basic Skype for Business topology. At the end of this phase most enterprise users should be able to use their Skype for Business enabled devices and workstations to communicate and collaborate internally with direct Skype for Business to Skype for Business communications. This internal collaboration capability includes voice, video, and application sharing. On premise deployments might include the [office web application services][3] as part of this phase as well (if they are not already in the environment for Sharepoint or other reasons).

[<img class="size-medium wp-image-1481 aligncenter" src="/wp-content/uploads/2015/07/Phase-11.jpg?resize=300%2C298" alt="Phase-1" width="300" height="298" srcset="/wp-content/uploads/2015/07/Phase-11.jpg?resize=300%2C298 300w, wp-content/uploads/2015/07/Phase-11.jpg?resize=150%2C150 150w, wp-content/uploads/2015/07/Phase-11.jpg?w=655 655w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][4]

## Phase 2 – Edge Access, Mobility, and Federation

This phase consists of configuring Skype for Business servers at the edge of the network and includes setup of one or more Skype for Business edge access servers, external IP addresses, and DNS addresses. The edge services allow for non-VPN connected enterprise workstations to still use the Skype for Business client securely from the outside network. The edge services also allow for direct Skype for Business communication with other federated services (such as Skype and XMPP based IM services). Optionally, you can also configure selective or open federation at this time for cross organization Skype for Business communication with your business partners.

<p style="text-align: left;">
  <a href="/wp-content/uploads/2015/07/Phase-21.jpg"><img class="size-medium wp-image-1482 aligncenter" src="/wp-content/uploads/2015/07/Phase-21.jpg?resize=205%2C300" alt="Phase-2" width="205" height="300" srcset="/wp-content/uploads/2015/07/Phase-21.jpg?resize=205%2C300 205w, wp-content/uploads/2015/07/Phase-21.jpg?resize=701%2C1024 701w, wp-content/uploads/2015/07/Phase-21.jpg?w=707 707w" sizes="(max-width: 205px) 100vw, 205px" data-recalc-dims="1" /></a>
</p>

By the end of this phase your users will be able to utilize the Skype for Business client across many devices both on and off your network. This is also an ideal phase to discuss and re-architect the edge of your network (if required) to accommodate one or, ideally, two DMZ&#8217;s for increased security.

> **Note:** This phase usually includes setup and configuration of reverse proxy services directly from the external network to your internal Skype for Business pool. The reverse proxy services are used for Skype for Business access from mobile devices and the Skype for Business web client among other things.

&nbsp;

## Phase 3 – PBX Integration

Up through phases 1 and 2 Skype for Business is capable of being used between Skype for Business capable devices within and outside of the organization. You can also host Skype for Business meetings that can be joined over the web. What you cannot do is dial a number from your phone to call a Skype for Business user or meeting. Phase 3 extends the Skype for Business infrastructure out to the public phone network by integrating with the current PBX to enable PSTN usage and overcome this limitation.

Skype for Business can be deployed to entirely replace the existing PBX infrastructure or, in many cases, be integrated in with a SIP capable phone system. In this phase we focus on PBX integration instead of replacement. This integration is typically limited a small handful of users or conference number as a proof of concept for the business. Some organizations stay at this integration level and go the route of setting up something called &#8216;remote call control&#8217; enabled users (which is mutually exclusive from enterprise voice enabled users). This might be done if there is a significant investment in the current PBX and phones that are connected to it. This requires vendor specific client plugins and can be quirky to setup and maintain and is not an encouraged route to take from Microsoft&#8217;s perspective.

With PBX integration it is common to replace existing third party conferencing solutions (i.e. WebEx) at your central office. You can also realize your current phone infrastructure investments longer with some extra work and configuration. This entire phase is reliant upon a supported IP based PBX and may not be possible in every environment. In these cases an organization might go directly to Phase 4.

I like to split this phase out into two possible scenarios. In one scenario we are looking a coexistence using a VoIP gateway. This essentially puts a new device between the existing PBX and your PSTN provider and splits out call flow depending on factors like AD attributes for users. This is not an option for environments which do not have a SIP capable PBX.

[<img class="size-medium wp-image-1483 aligncenter" src="/wp-content/uploads/2015/07/Phase-3-Coexistence.jpg?resize=300%2C294" alt="Phase-3-Coexistence" width="300" height="294" srcset="/wp-content/uploads/2015/07/Phase-3-Coexistence.jpg?resize=300%2C294 300w, /wp-content/uploads/2015/07/Phase-3-Coexistence.jpg?w=712 712w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][5]

Otherwise you can simply integrate Skype for Business with your existing PBX. You will see this being done for most VoIP capable PBXes. This leaves the onus to the PBX to route inbound calls to Lync intelligently. What you need to be aware of in this situation is that eventually you will need to move in and outbound call flow to another gateway device (coexistence) if you are to remove the old PBX anyway. Integration can be a nice temporary solution for testing out Skype for Business PSTN capabilities though.

[<img class="size-medium wp-image-1484 aligncenter" src="/wp-content/uploads/2015/07/Phase-3-Integration.jpg?resize=300%2C284" alt="Phase-3-Integration" width="300" height="284" srcset="/wp-content/uploads/2015/07/Phase-3-Integration.jpg?resize=300%2C284 300w, /wp-content/uploads/2015/07/Phase-3-Integration.jpg?w=710 710w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][6]

&nbsp;

## Phase 4 – PBX Replacement

When Skype for Business is integrated with your PBX you are left with two infrastructures to maintain and support. Number assignments become more complex as knowledge of two systems becomes necessary. Your dial plans and routes also tend to be more complicated and error prone. But with the correct hardware purchases an organization might opt to entirely replace their existing PBX with Skype for Business. A full Skype for Business voice solution opens a wide range of possibilities for your end users and can reduce costs over time. When you fully replace your existing PBX you can physically replace phones with Skype for Business compliant devices, and you can have phone numbers which follow employees everywhere from their cell phone, to their iPad, to their physical phones.

[<img class="size-medium wp-image-1487 aligncenter" src="/wp-content/uploads/2015/07/Phase-41.jpg?resize=300%2C258" alt="Phase-4" width="300" height="258" srcset="/wp-content/uploads/2015/07/Phase-41.jpg?resize=300%2C258 300w, wp-content/uploads/2015/07/Phase-41.jpg?w=721 721w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][7]

## Up Next

Now that we are all on the same page we can start to look at better preparing yourself for Phases 3 and 4 of your migration. To do this we will need to better understand your current phone system and provider configuration.  If you had enough foresight to plan for enterprise voice instead of it organically happening in your environment then it should be noted that you can begin much of the information gathering for the final phases of the deployment while you are implementing the first phases.

If you like the diagrams in this article I&#8217;ve [uploaded them into Github][8] for your convenience and reuse. Stay tuned for part 2 of this series where we will talk about the importance of being nice to people so we can get the information we need to help make your voice deployments easier.

 [1]: http://blog.ucomsgeek.com/2014/02/pbx-replacement-series-pbx-network.html
 [2]: wp-content/uploads/2015/07/PSTNProvider_Tax.jpg
 [3]: https://technet.microsoft.com/en-us/library/jj219458.aspx
 [4]: wp-content/uploads/2015/07/Phase-11.jpg
 [5]: /wp-content/uploads/2015/07/Phase-3-Coexistence.jpg
 [6]: /wp-content/uploads/2015/07/Phase-3-Integration.jpg
 [7]: wp-content/uploads/2015/07/Phase-41.jpg
 [8]: https://github.com/zloeber/Unified-Communications