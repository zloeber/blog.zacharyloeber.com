---
title: 'Skype For Business: Planning for Voice – Part 3'
author: Zachary Loeber
type: post
date: 2015-09-12T20:05:26+00:00
url: /blog/2015/09/12/skype-for-business-planning-for-voice-part-3/
categories:
  - Lync
  - Microsoft
  - Skype For Business
  - System Administration
tags:
  - Lync 2013
  - Lync Server 2013
  - Lync Voice
  - Microsoft
  - PSC
  - Skype For Business
  - Sysadmin
  - System Administration

---
If you have been following along this series you already know the importance of getting a recent PSTN provider bill and performing an onsite visit. Next we will go into more depth on how the site PSTN is configured with your PBX at a site. There is lots of ground to cover so lets dive right in!
  
<!--more-->

# PSTN Configuration

There are all kinds of wonky telephony configurations out there. It is your job to figure out your own special kind of wonkiness ahead of time so you can plan for your PBX replacement accordingly. Understanding what you currently have goes beyond knowing how many T1s you have running to the building. You need to know channel selection methodologies, if selective routing is being performed (ie. long distance going out one T1 and local calling out another), and more.

Having replaced multiple phone systems I’ve come up with a questionnaire that should be filled out on a per site basis that covers a wide range of configuration options and can be used as a good starting point. I like to send this questionnaire out to each site admin ahead of time to see what people think they have. To be fair, usually only the most fastidious of site administrators are able to fully get this form filled out though. But occasionally some site administrators are able to respond with some measure of accuracy so that&#8217;s good! Even then, I find that it is extremely important to validate what has been entered with an onsite discovery visit to confirm everything first hand (as discussed in the prior article).

The questionnaire is broken down into multiple worksheets. It is expected that more worksheets will be added as required (or ancillary documentation is provided) in several areas.

## Questionnaire &#8211; General

This section contains general information about the site that is essential to know. This includes known local area codes, the primary site contact, full address, main number, and if there are any known unique phone requirements. That last question is really to get whomever is filling out the form to start thinking ahead about their environment. More information is better at this point.

[<img class="aligncenter size-medium wp-image-1520" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-General.jpg?resize=300%2C146" alt="Site-PSTN-Conversion-Questionnaire-General" width="300" height="146" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-General.jpg?resize=300%2C146 300w, wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-General.jpg?w=897 897w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][1]

## Questionnaire &#8211; PBX

This worksheet is really just a place to remind people that you need access to the current PBX. Any diagrams, worksheets, directories, or nuances to the system should be noted here if possible.

[<img class="aligncenter size-medium wp-image-1523" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PBX-1.jpg?resize=300%2C181" alt="Site-PSTN-Conversion-Questionnaire-PBX-1" width="300" height="181" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PBX-1.jpg?resize=300%2C181 300w, wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PBX-1.jpg?w=639 639w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][2]

> **Tip:** Do not assume that every T1 or ISDN line you see is something that is connected to a provider! I narrowly prevented a client from purchasing a 4x ISDN card for a new gateway device (which is not cheap) because there were 4 ISDN lines that were actually just connected between the PBX and the voicemail server. Part of this PBX worksheet explicitly splits out the voicemail server information as a mild reminder of the fact that these systems are often not handled directly by the PBX.

## Questionnaire &#8211; DIDs

This is where things start to get a bit cumbersome. Essentially any known information on the current DID assignments would be great to have early on. Many times what is provided here is wildly outdated but something is better than nothing. With access to the current PBX and some fortitude maybe you can find a way to export this information yourself to validate. In the worst case scenario you end up going around the office and pulling an inventory of active users and the numbers they believe they are assigned.

[<img class="aligncenter size-medium wp-image-1524" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-DIDs.jpg?resize=300%2C250" alt="Site-PSTN-Conversion-Questionnaire-DIDs" width="300" height="250" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-DIDs.jpg?resize=300%2C250 300w, wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-DIDs.jpg?w=909 909w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]

> **Tip: **You do need the DID assignments on a per user basis. More so you will want the ranges of numbers that the site actually owns. It is vital to get this list from the provider (though it will certainly take some finagling to procure). Also, don&#8217;t assume that a list of extensions and users represents anything logical. They may just be random internal only extensions behind any number of public numbers!

## Questionnaire &#8211; PSTN Configuration

This is the meat and potatoes of the workbook. Pretty much everything any implementation engineer (from Sonus/Audiocodes) might need to deploy a new PSTN gateway should be covered in this worksheet. There are areas for the following:

  * PSTN Provider Information
  * T1/E1 Lines
  * ISDN Lines
  * Analog Lines
  * SIP Trunks
  * Media Settings

The PSTN provider information area is basic stuff so lets skip to the T1 (US) or E1 (EU) section.

### T1/E1 Lines

[<img class="aligncenter size-medium wp-image-1527" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-1.jpg?resize=300%2C276" alt="Site-PSTN-Conversion-Questionnaire-PSTN-1" width="300" height="276" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-1.jpg?resize=300%2C276 300w, wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-1.jpg?w=776 776w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][4]

Aside from a basic count of lines there is some pretty specific information being requested. The most important for a migration to new equipment would be the framing method and protocol type. If you are lucky you can infer this information from the current PBX configuration or the media gateways it uses (For example, Cisco Call Manager configuration information can be found in the GUI or directly in the routers it pushes configs down to). If in doubt you can connect with the provider and they should be able to confirm what they expect these to be set to.

> **Tip**: If you are not entirely certain what the framing and protocol types on a T1 line is then try ESF with CRC6 (extended super frame) and ISDN. It is not always correct but it is quite common. You know you &#8216;might&#8217; be using the correct settings if the T1 line goes yellow/orange for a few seconds then goes green. If that does not work I&#8217;d start cycling trough the framing types first to try and get the right combination.

I also leave just one section for T1/E1 line information. Ideally you will validate each line for as much information as you can possibly gather. This includes channels used, the channel selection method, circuit IDs, and purpose where possible. If 1 out of 3 T1&#8217;s is used for a direct connection to an Australian office then that is extremely important to know after all!

> **Tip:** Not listed in the questionnaire is the T1 channel selection mode. This would be the method that the provider chooses to select channels on the T1 line for your inbound calls. This is almost certainly going to be cyclic ascending. So the provider will start the first inbound call on channel 0, then if that call is still active the next call will be sent down channel 1, the next on 2, and so on. You, on the other hand, will not want to waste time sending your outbound calls out these channels but instead will use a cyclic descending method for channel selection (starting at the topmost channel and working your way down).
> 
> So, if you will be putting a gateway in between your old PBX and the T1s to split out calls to Skype For Business then your T1 trunks will be set to select channels cyclic descending on the connection to the T1 to the provider and cyclic ascending on the connection back to the old PBX.

Another item in the list is how many digits of a phone number the provider will send to the PBX and what the provider expects to get from the PBX in your outbound calls. On T1s I&#8217;ve seen as few as 3 digits being sent on inbound calls! This is not the norm though. Usually there are between 4 and 10 digits. Again, the provider can confirm this. Otherwise you will be reading through syslogs on your new gateway the night of the site cutover and having to figure it out on the fly.

> **What about PRI&#8217;s?**
> 
> Although I don&#8217;t explicitly list PRI circuits in the questionnaire you can assume that for this exercise PRI&#8217;s and T1&#8217;s are one and the same. PRI and BRI are really [different ISDN interfaces][5]. PRIs are often bundled into [T-carrier][6] or [E-carrier][7] lines and so you might often hear people say that they have a &#8216;PRI&#8217; and not a T1. Just nod and agree with them as they generally have the right idea just the wrong wording. This may also explain why you may see a bill that lists 24x ISDN lines instead of a single T1 line.
> 
> As always, I&#8217;m oversimplifying this terminology nuance. I recommend reading through the wikipedia links to get a more comprehensive understanding of all this telco jargon instead of just taking my word on it.

### ISDN Lines

I had to add this section in the questionnaire as technically you may have a site with ISDN lines coming in from your carrier. In reality, if you do have this kind of technology being used to route voice calls to the PSTN then you really need to look at migrating whatever numbers you have tied to the ISDN lines to something else. In every case I&#8217;ve experienced ISDN lines being terminated at an office they were found to be unneeded and were summarily replaced with VoIP devices. If you do have these lines they may be dedicated for conference rooms or as a means of communication between different components of a PBX.

[<img class="aligncenter size-medium wp-image-1529" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-2.jpg?resize=300%2C237" alt="Site-PSTN-Conversion-Questionnaire-PSTN-2" width="300" height="237" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-2.jpg?resize=300%2C237 300w, wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-2.jpg?w=778 778w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][8]

### Analog Lines

Analog lines will be found in your office in two varieties. One kind is directly from your carrier to a punchdown block and, from there, run directly to your PBX or throughout the office to individual jacks. A great example of this is found on most security systems that phone home or third party services when alarms are tripped (such as ADT or others). These are almost always going to be on separate analog lines run from another (or even the same) carriers. Good news is that you really aren&#8217;t that interested in anything not being handled by the legacy PBX so you can usually ignore these isolated systems in your assessments.

The other kind of analog lines you will see are those that originate from your PBX, an analog gateway connected to the PBX, or an ATA device which is connected to the PBX. These are used as a way to connect with legacy devices like modems, intercoms, or door systems.

> **Tip:** You will hear ATA and &#8216;Analog Gateway&#8217; used interchangeably. This is because they are essentially the same devices but at different port densities. Analog gateways are usually above 4 ports with common sizes being 8, 16, and 24 analog lines. Analog gateways under 24 lines usually have individual RJ-9 2-wire telephone ports. At 24 lines you will often see [50-pin Amphenol connectors][9] being used instead. ATA devices are most commonly found behind fax machines or all-in-one fax capable printers where you may not want to run an analog line.

### SIP Trunks & Media Settings

It is entirely possible that you might be integrating with an already existing SIP trunk from a carrier instead of some dusty old T1/E1 lines. If so then you still need to know how to interface with them. Likely there will already be some good carrier specific guides to be found for integration with your chosen vendor&#8217;s gateway. It should be noted that if you are already using a Session Border Controller (SBC) to integrate with a SIP provider then there is a good chance you can use it to integrate with Skype For Business as well!

[<img class="aligncenter size-medium wp-image-1531" src="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-3.jpg?resize=300%2C128" alt="Site-PSTN-Conversion-Questionnaire-PSTN-3" width="300" height="128" srcset="/wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-3.jpg?resize=300%2C128 300w, /wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-3.jpg?w=776 776w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][10]

I included the media settings part of the questionnaire as I&#8217;ve seen these settings be requested from implementation engineers. For a Lync/Skype deployment you will almost certainly be choosing G.711 (u-law or a-law). G.711 is sufficient for analog level narrow-band crappy quality voice everyone is used to over the PSTN. [Lync trunks only support G.711 as well][11].

> **Tip: Hidden Costs**
> 
> If you can do G.729 to the provider go for it as it will allow you to cram more active calls in the same bandwidth. G.722 starts to sound much better but there are hidden costs involved. As Lync/Skype will only support G.711 you will likely have to &#8216;transcode&#8217; the calls on the SBC back to your mediation servers (convert from one codec to another). This transcoding is almost always an extra license on the device and may even require extra processing power depending on your call volumes.
> 
> SIP licensing is also almost always tacked on separately to gateway purchases. Audiocodes (and most gateway vendors) will give you the T1/E1 to SIP call routing for free. The moment you start performing SIP to SIP routing of calls an additional license will need to be purchased. This is very important to know up front when designing call routing between different systems!
> 
> Usually SIP licensing is sold in counts representing total number of concurrent SIP connections. In a distributed environment this licensing can be difficult to manage. I&#8217;d work with your vendor to discuss some new pricing models and technologies that I&#8217;ve heard wind of that allow you to float licenses between devices in a single pool.

&nbsp;

## Conclusion

I think that is more than enough information for today. Hopefully this is enough to jump-start your discovery process. I do not profess to be an industry expert on the telco side so I welcome corrections to anything in this article. As always I&#8217;ve uploaded this workbook with the rest of the resources from this series of articles to [a github repository for your convenience][12].

 [1]: wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-General.jpg
 [2]: wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PBX-1.jpg
 [3]: wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-DIDs.jpg
 [4]: wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-1.jpg
 [5]: https://en.wikipedia.org/wiki/Integrated_Services_Digital_Network#Sample_call
 [6]: https://en.wikipedia.org/wiki/T-carrier
 [7]: https://en.wikipedia.org/wiki/E-carrier
 [8]: wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-2.jpg
 [9]: https://en.wikipedia.org/wiki/Telco_cable
 [10]: /wp-content/uploads/2015/09/Site-PSTN-Conversion-Questionnaire-PSTN-3.jpg
 [11]: https://technet.microsoft.com/en-us/library/Gg399005%28v=OCS.15%29.aspx?f=255&MSPPError=-2147217396
 [12]: https://github.com/zloeber/Unified-Communications