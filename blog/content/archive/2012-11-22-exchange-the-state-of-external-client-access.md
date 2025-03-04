---
title: Exchange – The State Of External Client Access
author: Zachary Loeber
type: post
date: 2012-11-22T19:58:04+00:00
url: /blog/2012/11/22/exchange-the-state-of-external-client-access/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - IIS
  - Lync
  - Microsoft
  - Networking
  - System Administration
  - Unified Access Gateway
tags:
  - Exchange 2010
  - Linux
  - Lync
  - Lync 2010
  - Networking
  - Security
  - System Administration
  - Windows

---
# Introduction

Most within the messaging and collaboration industry are hyped up about the next wave of Microsoft collaboration and messaging products which are soon to be released. Among these products is Exchange 2013 RTM. This type of release typically precedes yet another wave of architecture upgrades across the corporate landscape. Some of these (beta testers) will be will undoubtedly upgrade to Exchange 2013.

Other corporations will start to feel the burn to upgrade as well. These will be organizations which realize that their Exchange 2003/2007 infrastructure is nearing a decade old existence and cannot meet the demands of their ever growing mobile workforce. Realizing they are behind the curve, they may feel hastened to upgrade as well, possibly just to Exchange 2010. Regardless the reason in choosing to upgrade their messaging infrastructure, there are critical design decisions which need to be made in how clients access this infrastructure both internally and externally. This article focuses solely on the external access aspect of the infrastructure.

<!--more-->

# External Access Paths

I’ve seen many corporations which have great anti-spam solutions but have zero client access sanitation. A large part of this article stems from conversations with such clients who seem to believe that mail flow is the same as client access. Nothing could be further from the truth.

In a secure environment it is very likely that the path your mail is taking in and out of your network is completely different than that of client access traffic. Postini, FOPE, Message Labs, and other anti-spam/virus cloud providers serve a very relevant purpose. They sanitize and ensure that email itself is not a threat to your network. But there is another threat to be cognizant of, that of all the devices connecting to the Exchange client access servers. Client access commonly this includes Outlook Web Access (OWA), Outlook Anywhere (OA), and ActiveSync (A… just kidding it is just ActiveSync).

There aspects of a Lync deployment which also require a reverse proxy. On top of that, Lync has a specialized edge server. I’ll be strictly talking about reverse proxies and referencing Exchange. But it should be noted that from a design perspective, the placement of the internal and external interfaces for a Lync edge server is the exact same as that of your reverse proxy.

Here is a basic diagram showing traffic paths for both email and client access protocols.

[<img class="aligncenter size-medium wp-image-639" title="Exchange External Traffic Paths" src="/wp-content/uploads/2012/11/Exchange-Client-Access2.jpg?resize=203%2C300" alt="Exchange External Traffic Paths" width="203" height="300" srcset="/wp-content/uploads/2012/11/Exchange-Client-Access2.jpg?resize=203%2C300 203w, wp-content/uploads/2012/11/Exchange-Client-Access2.jpg?w=321 321w" sizes="(max-width: 203px) 100vw, 203px" data-recalc-dims="1" />][1]

In this diagram, the email traffic traverses the “anti-spam” device. This can be a separate device (such as an Ironport), a cloud-based service, or even a locally installed anti-spam service on the client access server. The external user traffic is blue and goes through a reverse proxy before going to the client access server.

The dotted blue line represents a direct external user connection to the client access server. This is not best practice and should not be considered as a valid and secure design. Companies which currently allow direct access through their firewall into their internal network to connect directly to legacy client access Exchange servers need to understand the risks of this design and factor a possible redesign into their upgrade plans.

# Role of the Reverse Proxy

Client access in Exchange is inherently an internal network-centric design. In Exchange 2007 on up, Exchange is designed around the Active Directory site structure, even for mail flow. This AD site structure is almost always based around the internal network which excludes the DMZ. Why exclude the DMZ in AD sites and services? Well from a security perspective you rarely want an internal domain joined computer floating out in your DMZ. The DMZ is for your high-risk external targets only. And in all versions of Exchange (minus those which include an edge 2010 server which I’ll cover as a side note towards the end of this article) each server must be domain joined members regardless of their role.

This puts us in a bit of a pickle as all those hipsters with their iPads and Androids really just want to access their email without being at the office from any device. And you probably want them to do so as well; it keeps them working and (arguably) more productive. So to fill the void on this the reverse proxy has been the historical go-to technology to deploy Exchange external client access functionality.  A reverse proxy can be setup in the DMZ to serve as a secure liaison between the wild and scary internet and your soft marshmallow of a security nightmare of an internal network.

If you setup a reverse proxy which just allowed traffic from the Internet to your client access server how much better is that then just opening up a firewall rule directly to the server? It isn’t. For the reverse proxy to be of value it needs to act as more than just a simple gateway. So what does the reverse proxy exactly do to make the environment more secure?

This is just from personal experience but I’ve come up with a general checklist of reverse proxy requirements. I welcome any other comments on this checklist as currently I believe I’m only covering some of the most basic requirements;

  * External HTTPS requests are filtered based on URL and path to ensure any other web server zero-day exploits are not easily exploited and that the client access server cannot be easily enumerated via scanning tools.
  * Network traffic entering through the proxy is compliant to industry protocol standards and not excessive.
  * Allows for more granular control and monitoring of traffic.
  * Perform URL/protocol redirection.
  * Bonus: It is nice if the reverse proxy can also load-balance requests between servers as well and intelligently know when a server is no longer available.
  * Bonus: It is easy to configure

A longer list of requirements to be considered can be found at [Open Web Application Security Project (OWASP)][2].

# Microsoft Reverse Proxy History

For many years now Exchange admins have relied on another Microsoft technology to act as a reverse proxy. This has historically been ISA, or more recently, TMG/UAG 2010. These products have proven to be robust in features, secure, and pretty resilient.  There is really a single product line with an additional (and recent) offspring based on the TMG product. If you follow the ISA genealogy you go from versions 2000, to 2004, to 2006, and finally to Threat Management Gateway 2010 (TMG). The product line further branches out to Unified Access Gateway 2010 (UAG) which pretty much runs on top of TMG but serves a different purpose.

From a 100 yard view, TMG is supposed to be for securing internal access out to the internet. UAG is for the reverse, wherein traffic from the internet to your internal network is secured. UAG is meant for deploying such things as Sharepoint portals, Direct Access, and even Exchange client access.

There was one other option which melds the best of an anti-spam device/service and a reverse proxy. This option was to run the Exchange 2010 Edge server on top of TMG 2010. This is actually a pretty clever idea but I’ve not seen it gather much traction in the industry. And with the end of life statement for the TMG product line this will no longer be a viable option shortly. But I&#8217;m getting ahead of myself, more on that part a bit later.

## The Ideal Setup

Let us take a quick sideline into another conversation I find myself repeatedly explaining to clients and administrators, the “ideal” edge infrastructure. As already mentioned, in the traditional network you don&#8217;t directly publish internal resources to the big bad internet. This also applies to a reverse proxy; otherwise it defeats the purpose of the device right? So we generally put the proxy device in the DMZ. This is a 100% viable solution but I typically like to implement a dual-DMZ approach which looks something like this:

[<img class="aligncenter size-medium wp-image-640" title="Exchange Dual DMZ Approach For External Access" src="/wp-content/uploads/2012/11/Dual-DMZ1.jpg?resize=300%2C137" alt="Exchange Dual DMZ Approach For External Access" width="300" height="137" srcset="/wp-content/uploads/2012/11/Dual-DMZ1.jpg?resize=300%2C137 300w, wp-content/uploads/2012/11/Dual-DMZ1.jpg?resize=500%2C229 500w, wp-content/uploads/2012/11/Dual-DMZ1.jpg?w=804 804w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" />][3]There is an outside DMZ and an inside DMZ. The proxy device straddles them both with a firewall at each end restricting access. This is logically one of the safest ways to secure your edge as a compromised firewall does not further compromise the entire network. Realistically though, having multiple firewalls is not always an option due to cost and management overhead. But you can still setup a dual-DMZ infrastructure but just using the same firewall for both DMZs. This leaves the option open for a future firewall down the line as well as minimizes surface area in the DMZ. You would usually then put all web servers and other DMZ devices in the external DMZ. If they were to get compromised then you don’t have to worry about your internal traffic being at risk of snooping or other malfeasance.

Going further into the realm of rainbows and unicorns (aka. the realm of ideals) to attain the highest levels of security some further separation would be done. Separate switches, virtual machine hosts, and shared storage would be dedicated to the DMZ. In this model any edge compromise would have extremely low chances of permitting further access into the inside network.

# TMG versus UAG

Are you done smirking at that audacious dual-DMZ design? Good, let’s continue on about the prevalence of TMG in the industry. Plainly put, many more organizations have chosen TMG over UAG as their reverse proxy solution. There are a few reasons why this has occurred. I’ll go over a few of my personal thoughts on the matter. Keep in mind I’ve deployed both solutions and really have no loyalty to one product over the other.

UAG is a great product with some really advanced technology and features. But UAG’s technology isn’t really an issue. The issue is that people have been using ISA for many years to secure their external client access to their internal Exchange servers. This continued on to TMG 2010 which has been widely deployed in conjunction with Exchange 2010 to this day. Administrators are generally comfortable with the ISA/TMG interface and have much less of a learning curve implementing the technology. There are even a few areas where TMG can be used which UAG is insufficient (for certificate based ActiveSync authentication among a few others).

Another factor in the decision to implement TMG versus UAG is that TMG is relatively cheap. How much cheaper? Let us discuss&#8230;.

## TMG Licensing

TMG utilizes a per CPU licensing model at around $1,500 a CPU. The cost per CPU goes up if you want to do TMG enterprise edition to setup an HA array or enterprise management server (for the previously mentioned array). These enterprise options are nice for managing cross site or multiple TMG architectures. But if you wanted to do so, you could setup two TMG 2010 standard servers as VMs, with a single vCPU a piece, and externally load balance them via DNS (the worst kind of load balancing, but still valid and supported) for around $3,000 in software costs for TMG.

I’ve seen this setup easily support several hundred users. I actually saw this model in place for 20,000+ users. It took around 4 TMG servers to support them all. But it worked like a charm.

## UAG Licensing

UAG has a fare more aggressive per-user/device licensing model. Here is the direct verbiage on UAG licensing:

  * A Client Access License (CAL) for each named or authenticated device or user that accesses a system running Unified Access Gateway. A Device CAL grants the right for one device (accessed by any user) to access the Unified Access Gateway server software. A User CAL permits one user (using any device) to access the server software.

Microsoft Unified Access Gateway licensing is around $15 per user or per device. This means anyone supporting over 200 users starts seeing rising costs to maintain legitimate licensing on a single UAG server deployment versus a TMG deployment. If you are setting up a UAG array (2 servers = 2x the licenses) you can half that user base to be 100 before you start getting to that $3,000 cost of a few TMG servers.

If you are a larger organization of 2000 users, and you want high availability, the cost for licensing (above and beyond server licensing) for just two UAG servers in an array becomes a staggering $60,000. This is just how it reads from the Microsoft Forefront Pricing and Licensing Guide. I welcome any arguments or corrections on this. I still think that MS licensing is a voodoo art which I&#8217;ll never fully understand.

# TMG Is Dead

Microsoft recently announced that TMG will no longer be developed and that licenses will be unavailable for purchase as of 12/1/2012. So here we are, a couple weeks away from the last opportunity to buy TMG licenses. As it stands there are very few documented reverse proxy solutions for you to use in your Exchange environments. TMG or UAG have been the go to guys for a while but now MS engineers and infrastructure architects need to start looking around for something else.

# It Is Not a Reverse Proxy

If you start searching around the term “reverse proxy” the results you get will likely not be very helpful. That is because the industry has shifted from the term of “reverse proxy” to a more concise term, “web application firewall”. And there are plenty of web application firewalls on the market.  If you are not afraid to get your hands into a bit of Linux or BSD there are even several open license alternatives which may be worthwhile to test out. After all, what was TMG if not just software running on top of Windows right? There are a few good lists which cover some free solutions [here][4] and [here][5]. Be a bit careful how you proceed with the multiple open source options. Some proxies like Varnish, Squid, and Pound provide little in terms of security.While others may not support all of the protocol functionality you want for such things like Outlook Anywhere (specifically NTLM authentication).

There are also some viable commercial web application gateways on the market. Juniper has an [SSG product line][6]. Barracuda has an [application gateway product line][7]. And I&#8217;m sure there are plenty others out there as well. I&#8217;ve yet to use these in much depth. I&#8217;ve used the Juniper products before, but only as an SSL device and not a web application gateway (but it really seemed quite capable in that arena).

# Conclusion

So we have come full circle. We have talked about the recent history of the reverse proxy. We have also gone over the current place a reverse proxy holds in an infrastructure. What next? Honestly, not a whole lot. There are other options to replace TMG, many of which are as fully mature as TMG had been. Just because a favored platform is self-declared as dead doesn’t mean other platforms are not as (or more) capable to take its place. Personally, I’m looking an nginx+naxsi at the moment (and if I can get it working expect another blog entry describing how I did it soon). But there are other, just as capable, web application gateways which will quickly fill the void of TMG as a “reverse proxy”.

 [1]: wp-content/uploads/2012/11/Exchange-Client-Access2.jpg
 [2]: https://www.owasp.org/index.php/Web_Application_Firewall
 [3]: wp-content/uploads/2012/11/Dual-DMZ1.jpg
 [4]: http://www.pentestit.com/list-open-source-web-application-firewalls/
 [5]: http://www.fromdev.com/2011/07/opensource-web-application-firewall-waf.html
 [6]: http://www.juniper.net/us/en/products-services/security/ssg-series/ "Juniper SSG Products"
 [7]: https://www.barracudanetworks.com/ns/products/web-site-firewall-models.php "Barracuda application gateways"