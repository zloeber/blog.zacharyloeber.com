---
title: 'Virtual Connect: Cisco MDS 9500 Fiber Connectivity'
author: Zachary Loeber
type: post
date: 2011-02-04T01:14:02+00:00
excerpt: 'I’ve done quite a bit of work with HP’s Virtual Connect  and C7000 blade enclosures in a contained (almost pure HP) environment. Today I ran into an issue which flummoxed both myself and an on-site engineer while attempting to connect the VC 8gb interconnect bays to the Cisco MDS fiber module for an upcoming (and exciting!) VMAX implementation.'
url: /blog/2011/02/03/virtual-connect-cisco-mds-9500-fiber-connectivity/
categories:
  - Cisco
  - Fiber
  - Networking
  - Storage
  - System Administration
  - Virtual Connect
tags:
  - Fiber
  - Networking
  - SAN
  - System Administration
  - Virtual Connect

---
I’ve done quite a bit of work with HP’s Virtual Connect  and C7000 blade enclosures in a contained (almost pure HP) environment. Today I ran into an issue which flummoxed both myself and an on-site engineer while attempting to connect the VC 8gb interconnect bays to the Cisco MDS fiber module for an upcoming (and exciting!) VMAX implementation.

<!--more-->The port status for any of the fiber ports in VC which were connected to the Cisco MDS enclosures would show up as port status of Unavailable and with a speed of COULD-NOT-LOGON. Additionally I saw that the MDS fiber modules all showed connection errors (little red X’s are never good). This happened on all the Interconnects and MDS ports which we tried to connect fiber between. As a test we even ran fiber up to a pair of brocade switch which routes most of the san traffic for our EVA. The brocade detected nothing and showed it was still unconnected.

In a quick browse of the web I didn’t come up with any ringers and had initially dismissed [this interesting HP article as it applied to the 4Gb ICs][1] and I was also ensured that NPIV was enabled by the on-site engineer and it was not an issue from all of his prior experiences. Well I shouldn’t have dismissed my gut feeling on the article as it would have saved me a few hours of time. I rounded back on this later on as a possible smoking gun for our issue and discovered that the fiber had indeed been all run and plugged in _prior_ to NPIV being enabled on the Cisco MDS. The article says nothing less than a reboot of the IC will fix this issue (and I will eventually do so soon with an accompanying firmware upgrade). I just moved the SFP and fiber to an unused port on the IC and  BAM! The green connectivity light came on for both the Cisco MDS and the Virtual connect!

Funny thing is that I just then noticed that the IC ports I moved the SFPs and fiber from were all still flashing orange, even after the SFP (and associated fiber) was moved from it to another location. I guess flashing orange does not mean simply “not connected” but rather it means “freaking disabled”, whoops. I suppose it is a good thing that it doesn’t work if it detects that NPIV is not enabled on the fiber switch it is attached to.  But VC should also probably auto-detect that kind of state a bit more gracefully and not require the whole interconnect bay be restarted.

 [1]: http://h20000.www2.hp.com/bizsupport/TechSupport/Document.jsp?objectID=c01753060&lang=en&cc=us&taskId=101&prodSeriesId=3942029&prodTypeId=3709945