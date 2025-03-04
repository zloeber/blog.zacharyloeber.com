---
title: 'Outlook 2010: Photo Sizing Tool'
author: Zachary Loeber
type: post
date: 2011-02-01T15:35:24+00:00
url: /blog/2011/02/01/outlook-2010-photo-sizing-tool/
categories:
  - Active Directory
  - Exchange
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Active Directory
  - Exchange 2010
  - Powershell
  - System Administration

---
We are about to get into full swing with our Exchange 2010 mailbox migrations and, soon afterwards, Office 2007 to 2010 upgrades as well. Unfortunately, we don&#8217;t have our Sharepoint farm upgraded to 2010 yet so there will be no automatic syncing of user photos into the GAL for those nice vanity pics which you can view in Outlook 2010. I know people like to be seen so I found a nice <a title="This little hack rocks!" href="http://www.mikepfeiffer.net/2010/05/manage-exchange-2010-thumbnail-photos-with-a-powershell-based-gui/" target="_blank">powershell based GUI </a>for our (awesome) service desk team to use to upload these photos for users as requested. But you still have to get these photos thumbnailed to approximately 96&#215;96 before uploading. Repeated manual labor is the anathema of any self respecting sysadmin who knows how to hack other people&#8217;s code to suit their needs. So I whipped up a very dirty (as in, &#8220;wow, get the bar of soap&#8221; dirty) hack which combines <a title="How to batch optimize your Exchange GAL Photos before importing to Active Directory" href="http://www.stevieg.org/2011/01/batch-optimize-exchange-gal-photos-importing-active-directory/comment-page-1/#comment-1085" target="_blank">this person&#8217;s clever photo-sizing hack</a> with the prior mentioned gui.
  
<!--more-->

This script would probably be best deployed with RDS on a 2008 R2 server for your team. We use just such a server that I setup in house as a management point to have a central spot to access administrative apps. Using the prior mentioned photo-sizing script methodology you will have to include a dll and ImageMagik&#8217;s convert.exe file in the same path as the script. I&#8217;m not going to go into all the things I left out of the script as this was primarily an exercise for me to become more familiar with setting up a powershell script with a nice gui interface (I miss my HTAs a bit). This could easily be improved (hell, if you run this without any modification it will fail if it isn&#8217;t in c:\Scripts\) if anyone were interested in doing so, I welcome your changes 🙂 Here is a quick screen-shot of me resizing the koala pic that comes with windows 7 as an example picture.

<div id="attachment_267" style="width: 395px" class="wp-caption alignleft">
  <a href="/wp-content/uploads/2011/01/Convert-For-GAL.jpg"><img class="size-full wp-image-267" title="Convert-For-GAL" src="/wp-content/uploads/2011/01/Convert-For-GAL.jpg?resize=385%2C287" alt="Automatically resize and crop photo for Exchange 2010" width="385" height="287" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    The photo conversion "GUI"
  </p>
</div>

I&#8217;d like to add a side note that the photos are uploaded to the GAL. This, in turn is polled by exchange to produce the offline address book daily by default. Then your outlook client does a full sync of that oab infrequently as well. Therefore it could be a good 3 days for the photos to show up for end users.

You can download the entire script with the ImageMagik stand-alone conversion utility (and dll) here:

[convert_picture.zip][1]

 [1]: .wp-content/uploads/2011/02/convert_picture.zip