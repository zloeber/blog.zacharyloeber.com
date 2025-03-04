---
title: 'Lync: Local and Site-to-Site Dial Plan GUI Script'
author: Zachary Loeber
type: post
date: 2015-01-13T02:37:46+00:00
excerpt: This script is meant to ease the process of creating and deploying site local and intersite dial plans for a Lync voice deployment. Optionally this GUI can also help to create the unassigned numbers and generic announcements.
url: /blog/2015/01/12/lync-local-and-site-to-site-dial-plan-gui-script/
categories:
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Lync
  - Lync 2010
  - Lync 2013
  - Lync Server 2013
  - Lync Voice
  - PSC

---
In a multiple, or even single, site VOIP deployment there are some  steps you can take to make life a whole lot easier on your end users. One of of the common features implemented across phone deployments (VoIP or otherwise) is site local and site-to-site dialing shortcuts. These shortcuts generally reduce the number of digits users have to dial to reach one another. In this post I&#8217;ll go over how you might setup such a dial plan in Lync. First I&#8217;ll go over how you might setup such a plan manually then I&#8217;ll provide a GUI tool to do the same thing.

<!--more-->

### The Basics

**Dial Plans** &#8211; Without going into Lync voice routing details already thoroughly covered elsewhere you need to already understand the following:

  1. Dial plans do serve a few other purposes but for the sake of this discussion A dial plan processes phone numbers you enter and optionally transforms them into other numbers.
  2. Dial plans can be assigned to scopes for user, Lync pool, Lync site, and global (the default).
  3. The Lync site scope is not AD sites and services but rather sites defined within the Lync topology. This is mostly important to understand in the context of this conversation as I’ve seen few cases where you can assign dial plans by this scope. This leaves you back to the next best scope when assigning dial plans, user.

You can learn all about dial plans from the source: <http://technet.microsoft.com/en-us/library/gg413082.aspx>

**Prefix** &#8211; Throughout this discussion I refer to &#8216;prefix&#8217; as any numbers that come before the local site DID 3 or 4 (or any digit length) dial plan. So if a site is using local 4 digit dialing in the US the prefix in the following DID is the underlined section.

<p style="text-align: center;">
  <em>+<strong><span style="text-decoration: underline;">1555555</span></strong></em>####
</p>

<p style="text-align: left;">
  This may not be the best way to term this part of a DID but it simplifies the overall DID structure enough for this conversation by making things nice and generic.
</p>

> <p style="text-align: left;">
>   <strong>Note:</strong> This has nothing to do with the dial plan&#8217;s &#8216;external access prefix&#8217; setting.
> </p>

<p style="text-align: left;">
  <strong>Site Code</strong> &#8211; An arbitrary (or seemingly so) set of digits preceding a dialed extension which get interpreted and transformed into the site prefix. Typically this is 1 or 2 digits for small to medium sized deployments. But site codes can also be used for any sized deployment or even just for a few sites within the deployment.
</p>

**Local Extension** &#8211; The left over digits after you have stripped away a common prefix will be the local extension. This tends to be between 4 to 6 digits.

**Global Extension** &#8211; If you put the site code together with the local extension you get the global extension. This is a personal preference for me but it tends to work out well in deployments to assign DIDs with extensions in the following fully E.164 formatted URI:

<p style="text-align: center;">
  <strong>tel:+<prefix><extension>;ext=<site code><extension></strong>
</p>

<p style="text-align: left;">
  This allows for a pretty large uniqueness range for Lync pin based logins for UC devices. It is also a bit easier for end users to remember.
</p>

## The Site Local Dial Plan

A site local dial plan (again, typically scoped at the user level) purpose is to make local calls between your users easier. In a non-Lync old-school world of handsets and old PBXes it is a great feature. Typically a site local plan takes the form of a 3 or 4 digit dial plan. Most PBX systems readily support this scenario and your heavy phone users tend to think it is the cat’s meow.

If you know how to use your Lync enabled devices or simply use the Lync client remembering extensions becomes less important. When you are migrating the main office phone system to Lync that you really shouldn&#8217;t have to remember extensions and codes to reach office staff anymore. But that means little to the personal assistant to the President of the company who is used to reaching others with a few digits now does it? Also, shorter numbers can make a printed local site directory listing more contrite I suppose.

## The Intersite Dial Plan

The ability to quickly reach people in the same site via shortened numbers is usually extended slightly for calls between sites. So a local 4 digit dial plan may turn into a 6 digit plan when attempting to reach other sites. That 6 digits would consist of a 2 digit site code and the 4 digits of a user’s DID. Having site codes makes it a bit easier to dial out to other sites and seems snazzy to end users too. Likely there is already some kind of intersite dialing codes in place that would be cool to be able to keep when upgrading the phone system (also anything the &#8216;old&#8217; system could do that the &#8216;new&#8217; system cannot becomes ammunition for complaints).

## Making The Dial Plans

To create site local dial plan rules you need to know some items up front, most importantly your phone number ranges and your site codes. It is important to bring up site codes which will be used for intersite dialing very early on. The site codes to use may not be as obvious as you’d think. Some companies have per site expense codes which are used or other internally important numbers that make sense to use.

The issue with creating either a 4 or 6 digit dialing plan a deployment is that DID ranges are very infrequently a cut and dry list. I&#8217;ve run into some DID allocations in metro areas which span several dozens of partial ranges or even more than one possible prefix. I’ve come up with some example data to illustrate this kind of DID allocation. This is the same example data that is included with the utility I’ve created and covers two sites with multiple DID ranges (all wildly fictitious of course).

> Chicago’s prefixes: 1222333 and 1222444
> 
> New York’s prefixes: 1555444 and 1555445

&nbsp;

### Issue 1: Crazy Regular Expressions

Say you do have all of your ranges laid out and are ready to create your 4 digit dialing. If you have some basic ranges or all your extensions are internal only then things are pretty easy to normalize. But if you have a heavily fragmented DID list you should not simply cater to the lowest common denominator. Lets take a peek at an example:

<p style="padding-left: 30px;">
  <strong>Range</strong>: 1-555-555-5000 to 1-555-555-5999
</p>

<p style="padding-left: 30px;">
  <strong>Regular expression (for 4 digits):</strong> ^(5[0-9]{3})$
</p>

<p style="padding-left: 30px;">
  <strong>Transform:</strong> +1555555$1
</p>

This is pretty easy to read:

<p style="padding-left: 30px;">
  Take anything that matches between () from the start of the dial string to the end (the ^ and $ ensure this), store the match in $1 and then transform to +1555555$1
</p>

> **Note:** Before I found [RegexNumRangeTool][1] I’d create these kind of regular expressions by hand. RegexNumRangeTool is still a great tool for the one off number range you need to match in a regular expression. It has one downfall in that it will automatically strip out leading zeros from results. This is bad for DID ranges but you can precede your ranges with an arbitrary number and then strip it from the results to get around it. I actually use the base code from this project in the utility I created (mostly unchanged!).

That prior example is just for one easy range. Here is a slightly modified range and its resulting regular expression.

<p style="padding-left: 30px;">
  <strong>Range:</strong> 1-555-555-6079 to 1-555-555-7102
</p>

<p style="padding-left: 30px;">
  <strong>Regular expression (for 4 digits):</strong> ^(6079|60[89][0-9]|6[1-9][0-9]{2}|70[0-9]{2}|710[0-2])$
</p>

<p style="padding-left: 30px;">
  <strong>Transform:</strong> +1555555$1
</p>

Quite a difference! Now if you had both ranges you had to account for you’d have to concatenate the regular expression to include both match possibilities:

<p style="padding-left: 30px;">
  ^(5[0-9]{3}|6079|60[89][0-9]|6[1-9][0-9]{2}|70[0-9]{2}|710[0-2])$
</p>

So why wouldn’t you just use something simpler like this?

<p style="padding-left: 30px;">
  ^(\d{4})$
</p>

If you include all 4 digit results then there is a chance you will be including non organizational numbers in your results. If you only have one prefix to transform the 4 digits with then this isn&#8217;t actually so bad (especially if the local office favorite take out joint is caught in the range I suppose, 4 digit fast dialing for delivery!). I&#8217;ve actually included an option in my utility to use these simplified transforms when possible.

The problem with this approach becomes more apparent when you have multiple prefixes to deal with at the same site. Using the same example ranges as above lets change the prefixs and see what happens:

<p style="padding-left: 30px;">
  <strong>Range 1</strong>: 1-555-555-5000 to 1-555-555-5999
</p>

<p style="padding-left: 30px;">
  <strong>Range 2 :</strong> 1-555-<span style="color: #00ff00;"><strong>666</strong></span>-6079 to 1-555-<span style="color: #00ff00;"><strong>666</strong></span>-7102
</p>

The first regular expression and transform do not change. But the second transform does change to the new prefix.

<p style="padding-left: 30px;">
  <strong>Transform:</strong> +1555<span style="color: #00ff00;"><strong>666</strong></span>$1
</p>

Because of this we cannot combine the regular expression. And if we use a generic 4 digit matching regex with one of the ranges as the transform you end up with 4 digit dialing that can never utilize the second range. This is what is known as an ambiguous result.

### Issue 2: Overlapping Ranges

If you look closely at the example ranges I’ve provided with the utility I&#8217;ve created what you end up having at Chicago is two ranges with different prefixes which have overlaps in their last 4 digit ranges. In these instances there is no one regular expression which will be able to resolve the 4 digits (5950 – 6000) to both prefixes.

If you want to do 4 digit dialing then you need to recognize that one or the other DID ranges simply should not be expected to work as a destination for local 4 digit or remote 6 digit dialing. The DIDs can still be used (perhaps for faxing or conference rooms or other purposes) but we will simply not be including them as a transformation in our dialing rules.

As can be expected, the smaller digit you want to use for local digit dialing the more likely you will have these kinds of overlaps. If you start playing around with the utility I’ve created you will see it even prevents digit counts which will result in overlapping beginning and ending DID prefixes in a single range. If you are going to go to the lower numbers for local digit dialing then you will need to split out your range entries accordingly.

## Some Reservations

It should be noted that it isn’t wise to automatically setup local and intersite dialing for every environment for a number of reasons. There are a few things to consider when doing this:

It is more administrative overhead when setting up new users as you will likely need to setup per user dial plans for the accounts as well when enabling them for Lync.

It can result in some pretty large regular expressions which means extra processing just to dial numbers. This usually doesn’t affect Lync clients on the desktop but it may affect physical phones if they are set to download and use Lync dial plans (something which you can do on the VVX series Polycom phones for instance).

Intersite dial plan normalizations do not really scale to very large deployments. In these cases it is not unheard of to use special routing codes in only some sites. The utility I’ve created can facilitate the creation of the correct normalization rules but was not meant to be used in these complex scenarios.

## The Utility

**<span style="text-decoration: underline;">Release Information</span>**

01/08/2015 &#8211; Initial Release

**<span style="text-decoration: underline;">Description</span>**

This script is meant to ease the process of creating and deploying site local and intersite dial plans within Lync. The general idea is to enter in all the local site DID ranges with local site codes. Then, based on a digit count, create both the normalization rules needed for local dialing and for intersite dialing. Optionally you can also create generic unassigned number ranges.

Example DID range data has been included which can be loaded for an initial test run. This data includes a few sites in the following format:

_<span style="text-decoration: underline;">Chicago</span>_

  1. Local 4 Digit dialing
  2. New York 6 digit dialing (20 + ####)

_<span style="text-decoration: underline;">New York</span>_

  1. Local 4 digit dialing
  2. Chicago 6 digit dialing (10 + ####)

_<span style="text-decoration: underline;">Global</span>_

  1. New York 6 digit dialing (20 + ####)
  2. Chicago 6 digit dialing (10 + ####)

The example data purposefully includes some overlaps that might cause ambiguous results thus generating some exceptions for the exceptions list.

**<span style="text-decoration: underline;">Notes</span>**

Here are some important things to be aware of regarding this utility. It would behoove you to read through these:

  * The exceptions are chosen a bit arbitrarily. For any duplicate found between effective DID ranges (based on the site local digits defined) there will always be a duplicate found in at least two ranges. One of these will be marked for the exceptions list, the other will be processed for possible transformation. A carefully input set of ranges can be used to manipulate which ranges are chosen.
  * Duplicate ranges can cause ambiguous transforms to occur so this utility attempts to isolate them and notify you to make exceptions in your DID assignments.
  * You can right-click and copy the contents of or clear any table in the form.
  * Ranges which are added that are exact duplicates will be ignored in processing.
  * The script output is meant to be a guideline and should be reviewed before running. What the script attempts to do is:

<li style="padding-left: 60px;">
  Creates a user scoped dial plan for each specified site
</li>
<li style="padding-left: 60px;">
  Removes the catch-all normalization rule for the created dial plan
</li>
<li style="padding-left: 60px;">
  Adds local digit dialing normalization rules for each created dial plan
</li>
<li style="padding-left: 60px;">
  Adds intersite digit dialing to all created dial plans for all sites
</li>
<li style="padding-left: 60px;">
  Add all intersite digit dialing normalization rules to the global dial plan as a fail safe for users which get created but are not assigned any site specific dial plan.
</li>
<li style="padding-left: 60px;">
  Re-adds the catch-all normalization rule for each per-site dial plan (so it ends up last)
</li>
<li style="padding-left: 60px;">
  Optionally you can also create some generic announcement services and have them associated with some unassigned DID ranges (that the script will also create).
</li>

  * This utility is not at all meant to be a replacement for the most excellent [Lync Dialing Rule Optimizer][2] by Ken Lasko. It should compliment it though. I&#8217;m actually going to say that if you don’t really understand Lync dial plans that you probably should refrain from using this or Ken&#8217;s tool until you do (I&#8217;ve inherited a few too many environments with wildly inappropriate or incorrect voice routing due to inexperienced engineers blindly running the optimizer&#8217;s results without truly understanding what they were inputting).
  * I&#8217;ve included an option for simplified normalization rules. If selected simplified rules will only get created for sites where there is a uniform prefix (no ambiguities).
  * The exceptions are listed with the original DID ranges but with the starting and ending digit columns updated to show the overlapped ranges (see screenshot).

## Screenshot

Here is an obligilitory screen shot of the utility I put together to help automate some of this process for you. The highlighted exception item is to show the last note listed in the notes.

[<img class="aligncenter size-medium wp-image-1363" src="/wp-content/uploads/2015/01/GUI-Screenshot2.jpg?resize=300%2C217" alt="GUI-Screenshot" width="300" height="217" srcset="/wp-content/uploads/2015/01/GUI-Screenshot2.jpg?resize=300%2C217 300w, wp-content/uploads/2015/01/GUI-Screenshot2.jpg?w=600 600w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]

## Output

Here is what the script output from the example input might look like:

<pre class="lang:powershell decode:true"># Create per-site dial plans	
New-CsDialPlan -Identity 'Chicago'	
New-CsDialPlan -Identity 'New York'	

# Add local site dialing normalization rules to the dial plans	
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'Chicago_4Digit-1' -Description 'Local 4 Digit local dialing for Chicago' -Pattern '^(5[0-9]{3}|6000|5[0-9]{3}|6000)$' -Translation '+1222333$1'
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'Chicago_4Digit-2' -Description 'Local 4 Digit local dialing for Chicago' -Pattern '^(59[5-9][0-9]|6000)$' -Translation '+1222444$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'New York_4Digit-1' -Description 'Local 4 Digit local dialing for New York' -Pattern '^(7[01][0-9]{2}|7200)$' -Translation '+1555444$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'New York_4Digit-2' -Description 'Local 4 Digit local dialing for New York' -Pattern '^(69[5-9][0-9]|70[0-4][0-9]|7050|69[5-9][0-9]|70[0-4][0-9]|7050)$' -Translation '+1555445$1'

# Remove the catch all normalization rules (optional)	
Remove-CsVoiceNormalizationRule -Identity 'Tag:Chicago/Keep All'
Remove-CsVoiceNormalizationRule -Identity 'Tag:New York/Keep All'

# Add Intersite dialing normalization rules to the dial plans	
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'New York_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(7[01][0-9]{2}|7200)$' -Translation '+1555444$1'
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'New York_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(69[5-9][0-9]|70[0-4][0-9]|7050|69[5-9][0-9]|70[0-4][0-9]|7050)$' -Translation '+1555445$1'
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'Chicago_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(5[0-9]{3}|6000|5[0-9]{3}|6000)$' -Translation '+1222333$1'
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'Chicago_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(59[5-9][0-9]|6000)$' -Translation '+1222444$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'New York_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(7[01][0-9]{2}|7200)$' -Translation '+1555444$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'New York_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(69[5-9][0-9]|70[0-4][0-9]|7050|69[5-9][0-9]|70[0-4][0-9]|7050)$' -Translation '+1555445$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'Chicago_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(5[0-9]{3}|6000|5[0-9]{3}|6000)$' -Translation '+1222333$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'Chicago_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(59[5-9][0-9]|6000)$' -Translation '+1222444$1'

# Re-add the catch all normalization rules so they end up last in the list	
New-CsVoiceNormalizationRule -Parent 'Chicago' -Name 'Keep All' -Pattern '^(\d+)$' -Translation '$1'
New-CsVoiceNormalizationRule -Parent 'New York' -Name 'Keep All' -Pattern '^(\d+)$' -Translation '$1'

# Add Global dialing normalization rules to the dial plans	
New-CsVoiceNormalizationRule -Parent 'Global' -Name 'Chicago_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(5[0-9]{3}|6000|5[0-9]{3}|6000)$' -Translation '+1222333$1'
New-CsVoiceNormalizationRule -Parent 'Global' -Name 'Chicago_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for Chicago' -Pattern '^10(59[5-9][0-9]|6000)$' -Translation '+1222444$1'
New-CsVoiceNormalizationRule -Parent 'Global' -Name 'New York_Intersite_6Digit-1' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(7[01][0-9]{2}|7200)$' -Translation '+1555444$1'
New-CsVoiceNormalizationRule -Parent 'Global' -Name 'New York_Intersite_6Digit-2' -Description 'Intersite 6 digit dialing for New York' -Pattern '^20(69[5-9][0-9]|70[0-4][0-9]|7050|69[5-9][0-9]|70[0-4][0-9]|7050)$' -Translation '+1555445$1'


$AnnouncementServices = @{}
get-cspool | Where {$_.Services -like "ApplicationServer*"} | Foreach {
    $AnnouncementName = "UnassignedNumberAnnouncement-$(($_.fqdn -split '\.')[0])"
    $AnnouncementService = "service:ApplicationServer:$($_.fqdn)"
    $AnnouncementServices.$AnnouncementName = $AnnouncementService
    New-CsAnnouncement -Parent $AnnouncementService -Name "$AnnouncementName" -TextToSpeechPrompt 'The number you have called is not assigned to anyone. Please contact the main number for a directory listing.' -Language "en-US"
}
$AnnouncementServices.Keys | Foreach {
    $AnnouncementService = $AnnouncementServices.$_
    $AnnouncementName = $_
    $Poolname = $AnnouncementService -replace 'service:ApplicationServer:',''
    $Poolname = ($Poolname -split '\.')[0]
    New-CsUnassignedNumber -Identity "$($Poolname)_Unassigned_Chicago_1" -NumberRangeStart '+12223335000' -NumberRangeEnd '+12223336000' -AnnouncementService $AnnouncementService -AnnouncementName $AnnouncementName
    New-CsUnassignedNumber -Identity "$($Poolname)_Unassigned_Chicago_2" -NumberRangeStart '+12223336010' -NumberRangeEnd '+12223336010' -AnnouncementService $AnnouncementService -AnnouncementName $AnnouncementName
    New-CsUnassignedNumber -Identity "$($Poolname)_Unassigned_Chicago_3" -NumberRangeStart '+12224445950' -NumberRangeEnd '+12224446000' -AnnouncementService $AnnouncementService -AnnouncementName $AnnouncementName
    New-CsUnassignedNumber -Identity "$($Poolname)_Unassigned_New York_1" -NumberRangeStart '+15554447000' -NumberRangeEnd '+15554447200' -AnnouncementService $AnnouncementService -AnnouncementName $AnnouncementName
    New-CsUnassignedNumber -Identity "$($Poolname)_Unassigned_New York_2" -NumberRangeStart '+15554456950' -NumberRangeEnd '+15554457050' -AnnouncementService $AnnouncementService -AnnouncementName $AnnouncementName
}</pre>

## Download

Get the script and example data set from either the [Microsoft technet gallery][4] or [my github repository][5].

 [1]: http://rxnrg.codeplex.com/
 [2]: https://www.lyncoptimizer.com/
 [3]: wp-content/uploads/2015/01/GUI-Screenshot2.jpg
 [4]: https://gallery.technet.microsoft.com/Lync-DID-Normalization-GUI-44b7251e
 [5]: https://github.com/zloeber/Powershell/tree/master/Lync/LyncDIDNormalizer