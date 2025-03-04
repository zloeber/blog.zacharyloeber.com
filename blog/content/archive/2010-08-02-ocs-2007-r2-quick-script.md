---
title: 'OCS 2007 R2: Quick Script'
author: Zachary Loeber
type: post
date: 2010-08-02T18:54:38+00:00
excerpt: 'I ran across this in one of the documents I wrote up while doing a side by side migration of our office communication server 2007  pool to 2007 R2. It is a quick script to automate the process of creating and assigning permissions for the shares needed in the front end server installation. I wrote it pretty quickly so use at your own discretion of course.'
url: /blog/2010/08/02/ocs-2007-r2-quick-script/
categories:
  - Microsoft
  - Networking
  - Office Communicator Server
  - System Administration

---
I ran across this in one of the documents I wrote up while doing a side by side migration of our office communication server 2007  pool to 2007 R2. It is a quick script to automate the process of creating and assigning permissions for the shares needed in the front end server installation. I wrote it pretty quickly so use at your own discretion of course. Save as a .cmd or .bat and run directly on the front end server.

<!--more-->

Two notes:

&#8211;       _RTCUniversalServerAdmins and Administrator = Full right on both NTFS and Share level permissions on all folders_ __

&#8211;       _Everyone group is removed from all share level permissions except Presentations_

 

<pre>mkdir c:\OCSShares</pre>

<pre>mkdir c:\OCSShares\Presentations</pre>

<pre>mkdir c:\OCSShares\Metadata</pre>

<pre>mkdir c:\OCSShares\ABS</pre>

<pre>mkdir c:\OCSShares\Applications</pre>

<pre>mkdir c:\OCSShares\Updates</pre>

<pre>mkdir c:\OCSShares\MeetingComp</pre>

 __

<pre>net share Presentations=c:\OCSShares\Presentations /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL /GRANT:everyone,READ /GRANT:NA1\RTCComponentUniversalServices,FULL /GRANT:NA1\RTCUniversalGuestAccessGroup,READ</pre>

<pre>icacls c:\OCSShares\Presentations  /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\Presentations  /GRANT administrators:(F)</pre>

<pre>icacls c:\OCSShares\Presentations  /GRANT everyone:(R)</pre>

<pre>icacls c:\OCSShares\Presentations  /GRANT NA1\RTCUniversalGuestAccessGroup:(RD)</pre>

<pre>icacls c:\OCSShares\Presentations  /GRANT NA1\RTCComponentUniversalServices:(M)</pre>

 __

<pre>net share Metadata=c:\OCSShares\Metadata /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL</pre>

<pre>/GRANT:NA1\RTCComponentUniversalServices,FULL</pre>

<pre>icacls c:\OCSShares\Metadata  /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\Metadata  /GRANT NA1\RTCComponentUniversalServices:(F)</pre>

<pre>icacls c:\OCSShares\Metadata  /GRANT administrators:(F)</pre>

 __

<pre>net share ABS=c:\OCSShares\ABS  /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL /GRANT:”Authenticated Users”,READ /GRANT:NA1\RTCHSUniversalServices,FULL /GRANT:NA1\RTCUniversalGuestAccessGroup,READ</pre>

 __

<pre>icacls c:\OCSShares\ABS  /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\ABS   /GRANT administrators:(F)</pre>

<pre>icacls c:\OCSShares\ABS  /GRANT NA1/RTCHSUniversalServices:(M)</pre>

<pre>icacls c:\OCSShares\ABS  /GRANT NA1/RTCUniversalGuestAccessGroup:(RD)</pre>

<pre>icacls c:\OCSShares\ABS  /GRANT ”Authenticated Users”:(RD)</pre>

<pre> </pre>

<pre>net share Applications=c:\OCSShares\Applications /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL</pre>

<pre>/GRANT:NA1\ RTCComponentUniversalServices,FULL</pre>

<pre>icacls c:\OCSShares\Applications /GRANT NA1\RTCComponentUniversalServices:(F)</pre>

<pre>icacls c:\OCSShares\Applications /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\Applications /GRANT administrators:(F)</pre>

 __

<pre>net share Updates=c:\OCSShares\Updates /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL /GRANT:NA1\RTCHSUniversalServices,READ /GRANT:NA1\RTCUniversalGuestAccessGroup,READ /GRANT:NA1\RTCComponentUniversalServices,FULL</pre>

 __

<pre>icacls c:\OCSShares\Updates /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\Updates /GRANT administrators:(F)</pre>

<pre>icacls c:\OCSShares\Updates /GRANT NA1\RTCUniversalGuestAccessGroup:(RD)</pre>

<pre>icacls c:\OCSShares\Updates /GRANT NA1\RTCHSUniversalServices:(RD)</pre>

 __

<pre>net share MeetingComp=c:\OCSShares\MeetingComp /GRANT:NA1\RTCUniversalServerAdmins,FULL /GRANT:administrators,FULL /GRANT:NA1\RTCComponentUniversalServices,FULL</pre>

 __

<pre>icacls c:\OCSShares\MeetingComp /GRANT NA1\RTCUniversalServerAdmins:(F)</pre>

<pre>icacls c:\OCSShares\MeetingComp /GRANT administrators:(F)</pre>

<pre>icacls c:\OCSShares\MeetingComp /GRANT NA1\RTCComponentUniversalServices:(M)</pre>