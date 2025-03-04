---
title: 'Skype For Business: Planning for Voice – Part 2'
author: Zachary Loeber
type: post
date: 2015-09-04T03:18:40+00:00
url: /blog/2015/09/03/skype-for-business-planning-for-voice-part-2/
categories:
  - Lync
  - Skype For Business
  - System Administration
tags:
  - Lync Server 2013
  - Lync Voice
  - Microsoft
  - network administration
  - PSC
  - Skype For Business
  - Sysadmin
  - System Administration

---
I&#8217;ve already gone over the basic phases of a Skype for Business enterprise voice deployment [in my prior article][1]. Now it is time to skip right over the first two of those phases and start preparing to replace your existing PBXs. To prepare you need to know what you are going to be replacing. In this article we will be focusing on beginning the information gathering process.

<!--more-->

The goal at this point is two-fold, First we need to understand how the current telephony provider is connecting to the office. Are there 3x T1 lines, 2x ISDN lines, and 4x pots lines all going to an Adtran device where things are muxed together before going to some ancient PBX without any IP capabilities? Or is there a SIP trunk connecting from an ITSP to an existing SBC (Lucky you if so!). Next we need to get a grip on what equipment is in use, how many phones you have, and other site specific information. Once we have the lay of the land we can then start to intelligently plan out the site migration strategy. The best place to start this discovery is looking at what you are paying for.

## The Bill

To me a recent copy of a bill from your current PSTN provider is the single most important item to procure early on in your discovery. You **need** to do this for every site you will be deploying early on for a number of reasons. Here are just a few of them:

  1. The provider is the only person who can fully confirm the site DID ranges you own. Do not trust excel sheets or PBX configurations to be correct!
  2. The bill for telcom related costs can be scrutinized against what you think you own vs. what you are actually paying for.
  3. You may need to jump through hoops to get support from your telcom provider and the bill is the first stepping stone in that process.

I&#8217;ve done whole site deployments without a bill. They kinda suck to do as you are intelligently guessing on so many things that you may either over purchase equipment (T1 cards are expensive!) or start assigning numbers you don&#8217;t actually own!

> **Note**: I use these terms interchangeably, PSTN provider, telo provider, telcom provider, and service provider. They all are the same entity, the company that sends you a huge bill every month for phone services!

It is very unlikely that any bill you look at will have all the fun information you need. Some items you then will have to weasel out of the provider either via an additional request or, if you&#8217;re lucky, their support line. Some items likely not on the bill will be your DIDs, Call Detail Reports, and just about everything we will be discussing in the PSTN configuration in the next article.

Also, when you ask for a site telephone bill, be certain to clarify that you are not interested in any kind of mobile phone bills they might be paying for their employees. You need to look on the bill for terms like &#8216;T1&#8217;, &#8216;PRI&#8217;, or &#8216;ISDN&#8217;. You may see a whole lot more ISDN lines than is believed to be owned. Some providers will bundle ISDN lines up into full or fractional T1s and show them as individual ISDN lines on the bill. If you see numbers of these in sets of 12 or 24 this is almost certainly the case. If an office is paying for dedicated ISDN lines then now is a perfect opportunity to ask why and if you cannot simply replace them with VoIP equipment instead. In fact maybe those dedicated ISDN lines are not even running to anything at all, you can determine this with&#8230;

## The Onsite Visit

It will be in your best interest to physically visit any site where you are looking to replace a PBX. This will help you correlate what is on the bill versus what is actually being used. This is particularly important for sites where the PBX has no IP accessible administrative interface. Aside from the bill correlation there are a number of other items to validate while you are there. Here is a list to get you started:

## [<img class="aligncenter size-medium wp-image-1507" src="/wp-content/uploads/2015/09/Site-Walkthrough-Checklist.jpg?resize=246%2C300" alt="Site-Walkthrough-Checklist" width="246" height="300" srcset="/wp-content/uploads/2015/09/Site-Walkthrough-Checklist.jpg?resize=246%2C300 246w, wp-content/uploads/2015/09/Site-Walkthrough-Checklist.jpg?w=576 576w" sizes="(max-width: 246px) 100vw, 246px" data-recalc-dims="1" />][2]

I&#8217;ve included this list in [the github repo I&#8217;ve started for this series][3] of articles for your convenience. I think I&#8217;ll end this article here as the next section is quite a bit larger. Next up we will start go talk about more detailed PSTN configuration and telephony inventory checklists I&#8217;ve prepared.

 [1]: /2015/08/25/skype-for-business-planning-for-voice-part-1/
 [2]: wp-content/uploads/2015/09/Site-Walkthrough-Checklist.jpg
 [3]: https://github.com/zloeber/Unified-Communications/blob/master/Site-Walkthrough-Checklist.xlsx?raw=true