---
title: 'Lync Book Review: Lync Server Cookbook'
author: Zachary Loeber
type: post
date: 2015-03-15T01:51:53+00:00
url: /blog/2015/03/14/lync-book-review-lync-server-cookbook/
categories:
  - Book Review
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Book Review
  - Lync
  - Lync 2013
  - Microsoft
  - Sysadmin
  - System Administration
  - Windows

---
I had planned to purchase this book at some point but instead was pleasantly surprised by an offer from one of the authors to provide an objective review of &#8216;[Lync Server Cookbook][1]&#8216;! As I have worked with the product in some form since LCS/OCS days I believe I can speak with some authority on subject matter and readily agreed. With that being said, lets start with the book&#8217;s overarching scope and structure.

<!--more-->

## General Book Structure

As with most &#8216;cookbook&#8217; type technical writings this book has several generalized topic areas with a subset of &#8216;recipes&#8217; to solve or configure situations you might encounter. From my experience the breadth of knowledge covered in books of this format can vary widely. But in general you should expect that these cookbooks are not all inclusive compendiums and are targeting readers with prior knowledge and experience in the presented subject matter. Lync Server Cookbook follows this formula pretty well in that some prior Lync knowledge certainly wouldn&#8217;t hurt before picking up this book. But I do not think you need much know how of the product to gain benefit from its contents. If you have done a basic deployment or are just becoming familiar with Lync then having a book of recipes chock full of extra notes and tips from industry professionals may be exactly what you need to take your skills to the next level.

If you are like me and have done several full Lync deployments but might have a less rounded out knowledge of some of the more nuanced technical aspects of the product then it is very likely you will get great value from this cookbook. Some items covered include but are certainly not limited to;

  * Office 365 Integration
  * Authentication Mechanisms (including the newly supported passive authentication!)
  * Enterprise voice DID management tools and tips
  * Federation Ethical Walls
  * Virtualization Sizing
  * Qos/QoE configuration and planning
  * Snooper/Wireshark troubleshooting

These are just a few areas that are covered. I found new or interesting information in all sections of the Lync Server Cookbook.

## The Good

This book was written by multiple authors, all of which are accomplished with the Lync product line. This broad experience base is extremely important with Lync 2013 as I believe it is rare to find any one Lync professional with real experience in all aspects of the Lync product. And you can tell the authors truly collaborated with one another and paid close attention to what they were assembling for this cookbook as well. Many of the recipes go into great detail which, from experience, I know comes from actual working knowledge of the product, not just hearsay.

There are copious side notes and references throughout the book. This is part of what makes a cookbook fun enough to want to read through even the recipes you may not think you need. Because if you read through the side notes you will find tools and techniques you may not have heard of or used otherwise. As many of the best Lync tools are community contributions or scripts you might be really missing out if you were to stick with strict adherence to using only the tools the product has to offer. The authors do not shy away from pointing out several tools that I have used in the past that feel like insider secrets.

## The Bad

It would be disingenuous of me to say that this book has zero issues. I would have like to have seen a more abundant and smaller sized selection of recipes for starters. I can think of several right off the top of my head that would have been perfect additions to this cookbook. Not all recipes need to be fully realized in their content or cleverness to be useful. Some smaller recipes that I&#8217;ve had to repeatedly share with those less experienced in Lync (or infrastructure in general) include the best way to setup local routes on edge servers (via netsh), when to avoid media bypass (typically over wireless), and designing multiple site DID dial plans. These would have been welcome additions to this tome.

Another area which threw me for a loop was the book&#8217;s section ordering. Although The Lync Cookbook is not to be an end all of product knowledge (as I previously discussed) it still felt a bit random. The book immediately starts with security topics like federation ethical walls policies and then goes all over the board from there. A more coherent structure around the different Lync modalities would have been welcome.

## Summary

Before I summarize my thoughts on this book I want to challenge you to find all the Lync 2013 Server books you can. Go ahead and do the Amazon search in another tab right now, I&#8217;ll wait&#8230;&#8230; Ok, so did you get maybe a single page of results back? There really are not that many books out there and I&#8217;ve read or own almost all of them. I believe that I can definitively pronounce that good Lync 2013 Server books are genuinely rather rare. Part of this might be due to how rapidly the technology is changing. Heck, there are new &#8216;features&#8217; being released in cumulative updates of the product! Another reason is that the Lync 2013 Server product has middle child syndrome. It is not too uncommon for businesses to skip an entire product release in their upgrade cycle (no matter how painful that may be). And many businesses upgraded to Exchange 2010 and got Lync 2010 thrown in with that upgrade. The excitement for the 2013 product line may have been a bit tepid because of this. In either case, the Lync Server 2013 deployment engineer or sysadmin seems like an under-served market.

Perhaps it is because of these reasons that I believe the cookbook format is exceptionally suited for Lync 2013 Server. When I was asked to review this book I was really concerned that I might be going through a cookbook of filler material (ie. how do I request a certificate, or how do I change a lync users policy, et cetera). This is primarily because honestly it would be easy to pad out a book like this with boring crap. But I can sincerely say that this book surpassed my expectations with truly informative subject matter containing interesting and useful recipes. This includes many non-technical recipes on top of the abundant technical material found within. For instance Chapter 6 is titled &#8216;Designing a Lync Solution &#8211; The Overlooked Aspects&#8217; and covers all kinds of goodies towards this end.

In the end I readily recommend adding the [Lync 2013 Cookbook][1] to your digital reader or bookshelf. Those with less experience on the Lync platform will be able to get valuable insider tips and tricks. And experienced Lync engineers and administrators will enjoy the broad experience base of several Lync experts&#8217; knowledge covering some of the more esoteric aspects of Lync Server. So there is something for everyone here.

 [1]: http://www.amazon.com/Lync-Server-Cookbook-Fabrizio-Volpe-ebook/dp/B00SVBFBQS/ref=dp_kinw_strp_1